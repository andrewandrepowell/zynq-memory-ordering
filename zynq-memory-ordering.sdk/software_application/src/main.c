/*
 * main.c
 *
 * Needed updates:
 * -Functions still need to be documented
 * -Safety checks need to be put into place to ensure enabled dummy task memory doesn't overlap with enabled hardware accelerator memory
 * -You may need to create your own software-based coherency functions for both inner and outer.
 * -Need to implement a way to acquire data reports from second cpu.
 * -You may want to use the virtual console with cpu 0 configured for UART.
 * -Perhaps, it might be a good idea to enable the json toggle command for the second cpu.
 *  Created on: Jul 2, 2015
 *      Author: Andrew Powell
 */

/****************** Include Files (User Defined)  ********************/

#include "main.h"

/********************** Globals (User Defined) ***********************/

static	XGpioPs 							emio_obj;					/**< EMIO object */
extern 	XScuGic 							xInterruptController;		/**< GIC object */
static	Task								tsk_obj;					/**< Main task object */
static	Synch								syn_obj;					/**< Driver for synchronizing the application's operation */
static 	Shared								shd_obj;					/**< Driver for shared memory between cpus */
static	Hardware 							hde_objs[HA_TOTAL];			/**< Hardware accelerator objects */
static	Memory								mry_objs[MEMORY_TOTAL];		/**< Memory objects for DDR and OCM */
static	Dummy_Task							dmy_objs[DUMMY_TASK_TOTAL];	/**< Dummy tasks for utilizing cache. */

/*************** Function Prototypes (User Defined) ******************/

extern		void 	prvSetupHardware();
extern		void 	Cli_setup(Shared* shd_obj);
extern		void 	Clv_setup(Shared* shd_obj);
extern		void 	Cli_Hardware_send_report(const Hardware* hde_obj);
extern		void 	Cli_Memory_send_report(const Memory* mry_obj);
extern 		void	Cli_Synch_send_report(const Synch* syn_obj);
extern		void 	Cli_Dummy_Task_send_report(const Dummy_Task* dmy_obj);
extern		void 	Cli_send_finish();
static 		void 	asset_callback(const char8 *file, s32 line);
static 		void 	task(void* param);
static		void	Dummy_Task_task(void* param);
static		void 	Main_configure_memory();
static		void	Main_configure_dummy_tasks();

/*************** Function Definitions (User Defined) *****************/

int main(void) {

	// First step should be to initialize FreeRTOS.
	prvSetupHardware();

	// Set up the main task.
	Task_setup(&tsk_obj,task,&tsk_obj,"Main Task");

	// Start the FreeRTOS scheduler.
	vTaskStartScheduler();
	return 0;
}

void asset_callback(const char8 *file, s32 line) {
	Cli_write_assert(file,line);
	while (1); // Program should freeze at this point
}

void Memory_static_setup() {

	// Please see 29.4 Programming Model in UG585 Zynq TRM to understand how
	// to properly configure the OCM's address mapping. Information on the ARMv7
	// instruction set, specifically the coprocessor instructions, can be found in
	// the ARM TRM for ARMv7. See Chapter B4. The following link is a good source on
	// ARM opcode, as well:
	//
	// https://sourceware.org/binutils/docs/as/ARM-Opcodes.html#ARM-Opcodes
	__asm__  volatile (
			"							DSB									\n"		// Complete all outstanding transactions.
			"							ISB									\n");	// Complete all outstanding transactions.
										Xil_L1ICacheEnable();						// Use the Standalone method for enabling the L1 Instruction Cache.
	__asm__  volatile (
			"							PLI		Memory_static_setup_0 		\n"		// Pre-load a 32-byte line (8 instructions) into the L1 Instruction Cache.
			"							PLI		Memory_static_setup_1		\n"		// Pre-load a 32-byte line (8 instructions) into the L1 Instruction Cache.
			"							PLI		Memory_static_setup_2		\n"		// Pre-load a 32-byte line (8 instructions) into the L1 Instruction Cache.
			"							ISB									\n"		// Ensure the pre-loading is finished before continuing.
			".align 					5									\n"		// Align the following instructions according the 32-byte line size of the cache.
			"Memory_static_setup_0:		MOVT	r0, %0						\n"		// Move the base address for the SLCR.
			"							MOVT	r1, #0						\n"		// Ensure the first 16 bits are clear.
			"							MOVW	r1, %2						\n"		// Move unlock value to r1.
			"							STR		r1, [r0, %1]				\n"		// Unlock the SLCR.
			"  							LDR		r1, [r0, %3]				\n"		// Load OCM_CFG register.
			"							AND		r1, r1, %4					\n"		// Make sure the bits corresponding to the OCM mapping are reset.
			"							ORR		r1, r1, %5					\n"		// Set the desired OCM memory map.
			"							STR		r1, [r0, %3]				\n"		// Store the new OCM_CFG configuration into memory.
			"Memory_static_setup_1:		MOVT	r1, #0						\n"		// Ensure the first 16 bits are clear.
			"							MOVW	r1, %7						\n"		// Move lock value into r1.
			"							STR		r1, [r0, %6]				\n"		// Lock the SLCR.
			"							MOVT	r0, %8						\n"		// Move base address for the MPCORE.
			"							MOVW	r1, #0						\n"		// Make sure the lower 16 bits of r1 are cleared.
			"							MOVT	r1, %10						\n"		// Move the starting filter address for DDR into r1.
			"							STR		r1, [r0, %9]				\n"		// Store the new starting filter address for DDR into memory.
			"							MOVT	r1, %12						\n"		// Move the ending filter address for DDR into r1.
			"Memory_static_setup_2:		STR		r1, [r0, %11]				\n"		// Store the new ending filter address for DDR into memory.
			"							LDR		r1, [r0, %13]				\n"		// Load SCU_CTRL register.
			"							AND		r1, r1, %14					\n"		// Make sure the bits corresponding to the address filtering are reset.
			"							ORR		r1, r1, %15					\n"		// Set the desired state of the address filter of the SCU.
			"							STR		r1, [r0, %13]				\n"		// Store the new configuration for SCU_CTRL.
			"							DMB									\n"		// Ensure all prior memory accesses are complete.
			:
			:	"i" (MEMORY_SLCR_BASE_ADDRESS>>16),				// %0
			 	"i" (MEMORY_SLCR_UNLOCK_OFFSET),				// %1
			 	"i" (MEMORY_SLCR_UNLOCK_VALUE),					// %2
			 	"i" (MEMORY_SLCR_OCM_CFG_OFFSET),				// %3
			 	"i" (~MEMORY_SLCR_OCM_CFG_MAP_BITS),			// %4
			 	"i" (MEMORY_SLCR_OCM_CFG_MAP_VALUE),			// %5
			 	"i" (MEMORY_SLCR_LOCK_OFFSET),					// %6
			 	"i" (MEMORY_SLCR_LOCK_VALUE),					// %7
			 	"i" (MEMORY_MPCORE_BASE_ADDRESS>>16),			// %8
			 	"i" (MEMORY_MPCORE_FIL_S_ADDR_OFFSET),  		// %9
			 	"i" (MEMORY_MPCORE_FIL_S_ADDR_VALUE>>16),		// %10
			 	"i" (MEMORY_MPCORE_FIL_E_ADDR_OFFSET),			// %11
			 	"i" (MEMORY_MPCORE_FIL_E_ADDR_VALUE>>16),		// %12
			 	"i" (MEMORY_MPCORE_SCU_CTRL_OFFSET),			// %13
			 	"i" (~MEMORY_MPCORE_SCU_CTRL_FIL_ENABLE_BITS),	// %14
			 	"i" (MEMORY_MPCORE_SCU_CTRL_FIL_ENABLE_VALUE)	// %15
			: 	"r0", "r1");									// The clobbers aren't necessary but added for completeness.

	__asm__ volatile (
			"NOP"
			:
			:
			:
			);

	return;
}

/*
void Memory_clean(unsigned int adr, unsigned int len) {
	const unsigned int IRQ_FIQ_MASK = 0xC0;
	const unsigned cacheline = 32;
	unsigned int end;
	unsigned int currmask;

	currmask = mfcpsr();
	mtcpsr(currmask | IRQ_FIQ_MASK);

	if (len != 0) {

		end = adr + len;
		adr = adr & ~(cacheline - 1);

		while (adr < end) {
			__asm__ __volatile__("MCR 	p15, 0, %0,  c7, c14, 1	\n" :: "r" (adr)); ;
			adr += cacheline;
		}
	}

	dsb();
	mtcpsr(currmask);
}

void Memory_invalidate(unsigned int adr, unsigned int len) {
	const unsigned int IRQ_FIQ_MASK = 0xC0;
	const unsigned cacheline = 32;
	unsigned int end;
	unsigned int currmask;

	currmask = mfcpsr();
	mtcpsr(currmask | IRQ_FIQ_MASK);

	if (len != 0) {
		// Back the starting address up to the start of a cache line
		// perform cache operations until adr+len
		end = adr + len;
		adr = adr & ~(cacheline - 1);

		while (adr < end) {
			__asm__ __volatile__("MCR p15, 0, %0,  c7,  c6, 1" :: "r" (adr));
			adr += cacheline;
		}
	}

	// Wait for L1 invalidate to complete
	dsb();
	mtcpsr(currmask);
}

#define Memory_memcpy_IMP 1
void* Memory_memcpy( void *pvDest, const void *pvSource, size_t ulBytes ) {

#if Memory_memcpy_IMP==0

	unsigned char *pcDest = ( unsigned char * ) pvDest, *pcSource = ( unsigned char * ) pvSource;
	size_t x;

	for( x = 0; x < ulBytes; x++ ) {
		*pcDest = *pcSource;
		pcDest++;
		pcSource++;
	}

	return pvDest;

#elif Memory_memcpy_IMP==1

#define bytes_per_transfer_arm  	32
#define bytes_per_transfer_neon		64

	// Run optimized transfer. Please see the following ARM link for more information
	// on the following inline assembly. Also review the ARMv7 TRM for more information
	// on the instructions themselves. Later, a NEON implementation should be in order.
	//
	// http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.faqs/ka13544.html

	register u32 size_0;
	register u32 size_1;

	size_0 = ulBytes / bytes_per_transfer_neon;
	size_1 = ulBytes % bytes_per_transfer_neon;

	if (size_0 != 0)
		__asm__ volatile (
				"Memory_memcpy_IMP_1_3:			\n"
				"PLD	[%1, %3]				\n"
				"VLDM	%1!, {d0 - d7}			\n"
				"VSTM	%0!, {d0 - d7}			\n"
				"SUBS	%2, %2, #1				\n"
				"BGE	Memory_memcpy_IMP_1_3	\n"
				:
				: "r" (pvDest), "r" (pvSource), "r" (size_0), "i" (bytes_per_transfer_neon*3)
				:
				);

	size_0 = size_1 / bytes_per_transfer_arm;
	size_1 = size_1 % bytes_per_transfer_arm;

	if (size_0 != 0)
		__asm__ __volatile__ (
				"Memory_memcpy_IMP_1_0:			\n"
				"LDMIA	%1!, {r3 - r10}			\n"
				"STMIA	%0!, {r3 - r10}			\n"
				"SUBS	%2, %2, #1				\n"
				"BGE	Memory_memcpy_IMP_1_0	\n"
				:
				: "r" (pvDest), "r" (pvSource), "r" (size_0)
				: "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10"
				);

	size_0 = size_1 / sizeof(u32);
	size_1 = size_1 % sizeof(u32);

	if (size_0 != 0)
		__asm__ volatile (
				"Memory_memcpy_IMP_1_1:			\n"
				"LDR 	r3, [%1], %3			\n"
				"STR	r3, [%0], %3			\n"
				"SUBS	%2, %2, #1				\n"
				"BGE	Memory_memcpy_IMP_1_1	\n"
				:
				: "r" (pvDest), "r" (pvSource), "r" (size_0), "i" (sizeof(u32))
				: "r3"
				);

	size_0 = size_1;

	if (size_0 != 0)
		__asm__ volatile (
				"Memory_memcpy_IMP_1_2:			\n"
				"LDRB 	r3, [%1], #1			\n"
				"STRB	r3, [%0], #1			\n"
				"SUBS	%2, %2, #1				\n"
				"BGE	Memory_memcpy_IMP_1_2	\n"
				:
				: "r" (pvDest), "r" (pvSource), "r" (size_0), "i" (sizeof(u32))
				: "r3"
				);

	return pvDest;

#undef bytes_per_transfer_arm
#undef bytes_per_transfer_neon

#endif
}
*/

void Memory_setup(Memory* mry_obj,int identifier,void* base_address,
		u32 max_transfer_size,u32 domain,int is_ocm_flag,
		Amp_PageAttribute policy_0,Amp_PageAttribute policy_1,char* string) {
	mry_obj->identifier = identifier;
	mry_obj->domain = domain;
	mry_obj->is_ocm_flag = (is_ocm_flag!=0);
	mry_obj->max_transfer_size = max_transfer_size;
	mry_obj->string = string;
	Memory_set_base_address(mry_obj,base_address);
	Memory_set_policies(mry_obj,policy_0,policy_1);
}

void Memory_set_base_address(Memory* mry_obj,void* base_address) {
	mry_obj->base_address = base_address;
}

void Memory_set_policies(Memory* mry_obj,Amp_PageAttribute policy_0,Amp_PageAttribute policy_1) {
	mry_obj->policy_0 = policy_0;
	if ((policy_0==Amp_strongly_ordered)||(policy_0==Amp_shareable_device)) {
		mry_obj->is_normal_memory_flag = 0;
		//mry_obj->policy_1 = Amp_non_cacheable;
		mry_obj->policy_1 = policy_0;
		Amp_setPageTable(policy_0,mry_obj->base_address,mry_obj->domain);
	} else {
		Xil_AssertVoid(!((policy_1==Amp_strongly_ordered)||(policy_1==Amp_shareable_device)));
		mry_obj->is_normal_memory_flag = 1;
		mry_obj->policy_1 = policy_1;
		Amp_setPageTable2(policy_0,policy_1,mry_obj->base_address,mry_obj->domain);
	}
}

int Memory_is_non_cacheable(Memory* mry_obj) {
	Amp_PageAttribute policy_0 = mry_obj->policy_0;
	Amp_PageAttribute policy_1 = mry_obj->policy_1;
	if ((policy_0==Amp_strongly_ordered)||(policy_0==Amp_shareable_device)||
			((policy_0==Amp_non_cacheable)&&(policy_1==Amp_non_cacheable))) {
		return 1;
	} else {
		return 0;
	}
}

void Monitor_setup(Monitor* mtr_obj,void* base_address) {
	Axi4_Metrics_Counter_setup(&mtr_obj->amc_obj,base_address);
	Counts_setup(&mtr_obj->cts_obj);
}

void Monitor_reset(Monitor* mtr_obj) {
	Axi4_Metrics_Counter_reset(&mtr_obj->amc_obj);
}

void Monitor_load(Monitor* mtr_obj) {
	Axi4_Metrics_Counter* amc_obj = &mtr_obj->amc_obj;
	Counts* cts_obj = &mtr_obj->cts_obj;
	cts_obj->count						= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_COUNTER);
	cts_obj->latency.write.total		= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_LATENCY_TOTAL_WRITE);
	cts_obj->latency.write.min 			= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_LATENCY_MIN_WRITE);
	cts_obj->latency.write.max			= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_LATENCY_MAX_WRITE);
	cts_obj->latency.read.total			= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_LATENCY_TOTAL_READ);
	cts_obj->latency.read.min			= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_LATENCY_MIN_READ);
	cts_obj->latency.read.max			= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_LATENCY_MAX_READ);
	cts_obj->transaction.write.total	= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_TRANSACTION_TOTAL_WRITE);
	cts_obj->transaction.read.total		= Axi4_Metrics_Counter_get_metric(amc_obj,Axi4_Metrics_Counter_Metric_TRANSACTION_TOTAL_READ);
}

void Hardware_setup(Hardware* hde_obj,Params* prs_obj,
		int identifier,int pin_run_operation,int is_connected_to_acp_flag,
		int is_64bit_flag,int is_cache_coherent_flag,u32 interrupt_id,
		void* hae_obj_base_address,void* mtr_obj_base_address,char* string) {

	// Assign the members.
	hde_obj->identifier = identifier;
	hde_obj->location = identifier;
	hde_obj->pin_run_operation = pin_run_operation;
	hde_obj->interrupt_id = interrupt_id;
	hde_obj->is_connected_to_acp_flag = (is_connected_to_acp_flag!=0);
	hde_obj->is_enabled_flag = 0;
	hde_obj->is_error_flag = 0;
	hde_obj->string = string;

	// Configure the default runtime-configurable parameters.
	Hardware_Params_set_burst_len(hde_obj,prs_obj->burst_len);
	Hardware_Params_set_transfer_size(hde_obj,prs_obj->transfer_size);
	Hardware_Params_set_memory(hde_obj,prs_obj->mry_obj);

	// Configure whether or not coherent requests should be made.
	Hardware_set_is_cache_coherent_flag(hde_obj,is_cache_coherent_flag);

	// Configure the hardware accelerator's method of enabling.
	IO_DIRECTION_OUT(pin_run_operation);
	IO_WRITE_LOW(pin_run_operation);

	// Configure the abstraction driver that directly accesses the hardware
	// accelerator's registers.
	Hardware_Accelerator_setup(&hde_obj->hae_obj,hae_obj_base_address,
			hde_obj,Hardware_run_operation_handler,
			hde_obj,Hardware_is_running_handler,
			is_64bit_flag);

	// Configure the monitors needed for counting clock cycles.
	Monitor_setup(&hde_obj->mtr_obj,mtr_obj_base_address);
	Arm_Counts_setup(&hde_obj->acs_obj);

	// Configure the hardware accelerator's corresponding interrupt.
	XScuGic_Connect_sc(interrupt_id,Hardware_interrupt_handler,hde_obj);
	XScuGic_SetPriorityTriggerType_sc(interrupt_id,HA_INTERRUPT_PRIORITY,XSCUGIC_SC_TRIGGER_RISING_EDGE);
}

void Hardware_run_operation_handler(void* void_hde_obj) {
	Hardware* hde_obj = (Hardware*)void_hde_obj;
	XScuGic_Enable_sc(hde_obj->interrupt_id);
	IO_WRITE_HIGH(hde_obj->pin_run_operation);
}

int Hardware_is_running_handler(void* void_hde_obj) {
	Hardware* hde_obj = (Hardware*)void_hde_obj;
	return IO_READ(hde_obj->pin_run_operation); // This may not work, so keep eye on this statement's effects
}

void Hardware_interrupt_handler(void* void_hde_obj) {
	Hardware* hde_obj = (Hardware*)void_hde_obj;
	XScuGic_Disable_sc(hde_obj->interrupt_id);
	IO_WRITE_LOW(hde_obj->pin_run_operation);
}

void Hardware_Params_set_burst_len(Hardware* hde_obj,int burst_len) {
	// At some point, you might want to add some better assertions here
	Params_set_burst_len(&hde_obj->prs_obj,burst_len);
}

void Hardware_Params_set_transfer_size(Hardware* hde_obj,int transfer_size) {
	// At some point, you might want to add some better assertions here
	Params_set_transfer_size(&hde_obj->prs_obj,transfer_size);
}

void Hardware_Params_set_memory(Hardware* hde_obj,Memory* mry_obj) {
	// At some point, you might want to add some better assertions here
	Params_set_memory(&hde_obj->prs_obj,mry_obj);
}

void Hardware_Params_configure(Hardware* hde_obj) {

	// Extract all the necessary objects.
	Params* prs_obj = &hde_obj->prs_obj;
	Hardware_Accelerator* hae_obj = &hde_obj->hae_obj;

	// Extract all the necessary data.
	int data_burst_len = prs_obj->burst_len;
	int transfer_size = prs_obj->transfer_size;
	void* write_address = Hardware_Params_get_write_address(hde_obj);
	void* read_address = Hardware_Params_get_read_address(hde_obj);
	int is_cache_coherent_flag = Hardware_is_cache_coherent(hde_obj)!=0;

	// Configure the hardware accelerator with the data.
	Hardware_Accelerator_set_data_burst_len(hae_obj,data_burst_len);
	Hardware_Accelerator_set_transfer_size(hae_obj,transfer_size);
	Hardware_Accelerator_set_write_address(hae_obj,write_address);
	Hardware_Accelerator_set_read_address(hae_obj,read_address);
	Hardware_Accelerator_set_write_coherent_flag(hae_obj,is_cache_coherent_flag);
	Hardware_Accelerator_set_read_coherent_flag(hae_obj,is_cache_coherent_flag);

	// Read back all the data and check for any discrepancies.
	Xil_AssertVoid(Hardware_Accelerator_get_data_burst_len(hae_obj)==data_burst_len);
	Xil_AssertVoid(Hardware_Accelerator_get_transfer_size(hae_obj)==transfer_size);
	Xil_AssertVoid(Hardware_Accelerator_get_write_address(hae_obj)==write_address);
	Xil_AssertVoid(Hardware_Accelerator_get_read_address(hae_obj)==read_address);
	Xil_AssertVoid(Hardware_Accelerator_get_write_coherent_flag(hae_obj)==is_cache_coherent_flag);
	Xil_AssertVoid(Hardware_Accelerator_get_read_coherent_flag(hae_obj)==is_cache_coherent_flag);
}

void Hardware_operation_generate(Hardware* hde_obj) {

	// Gather and allocate needed data.
	int i;
	int transfer_size = hde_obj->prs_obj.transfer_size;
	void* read_address = Hardware_Params_get_read_address(hde_obj);
	void* write_address = Hardware_Params_get_write_address(hde_obj);
	void* buffer = malloc(transfer_size);
	Arm_Counts* acs_obj = &hde_obj->acs_obj;
	Memory* mry_obj = hde_obj->prs_obj.mry_obj;
	//register int flush_cache_flag = (!Hardware_is_cache_coherent(hde_obj)&&Memory_is_normal_memory(mry_obj)&&!Memory_is_non_cacheable(mry_obj))||
	//								(!Amp_get_actlr_smp());
	register int flush_cache_flag = (!Hardware_is_cache_coherent(hde_obj)&&Memory_is_normal_memory(mry_obj)&&!Memory_is_non_cacheable(mry_obj));
	register int flush_both_caches_flag = !Memory_is_ocm(mry_obj);

	// Clear memory and reset flags.
	hde_obj->is_error_flag = 0;
	memset(write_address,0,transfer_size);
	memset(read_address,0,transfer_size);
	dsb();

	// Generate the data.
	for (i=0;i<transfer_size/Hardware_Accelerator_BYTES_PER_32b_WORD;i++) {
		((u32*)buffer)[i] = i;	// data that's generated is really simple; no reason for anything complex
	}

	// Start the core's APM to count clock cycles.
	dsb();
	Arm_Counts_start(acs_obj);

	// Write the data to the location from where the hardware accelerator will read.
	memcpy(read_address,buffer,transfer_size);

	// For memory regions whose configuration is normal and hardware accelerators
	// without cache-coherency, the corresponding cache region must be flushed to
	// main memory.
	if (flush_cache_flag) {
		if (flush_both_caches_flag) {
			Xil_DCacheFlushRange((unsigned int)read_address,transfer_size);
		} else {
			Xil_L1DCacheFlushRange((unsigned int)read_address,transfer_size);
		}
	}

	// Stop the core's APM to record the number of clock cycles needed
	// to perform the write operation. The stall occurs in the flush operation.
	dsb();
	Arm_Counts_end_total_write(acs_obj);

	// Free buffer
	free(buffer);
}

void Hardware_operation_check(Hardware* hde_obj) {

	// Gather and allocate needed data.
	int i;
	int transfer_size = hde_obj->prs_obj.transfer_size;
	void* read_address = Hardware_Params_get_read_address(hde_obj);
	void* write_address = Hardware_Params_get_write_address(hde_obj);
	void* buffer = malloc(transfer_size);
	Arm_Counts* acs_obj = &hde_obj->acs_obj;
	Memory* mry_obj = hde_obj->prs_obj.mry_obj;
	register int invalidate_cache_flag = !Hardware_is_cache_coherent(hde_obj)&&Memory_is_normal_memory(mry_obj)&&!Memory_is_non_cacheable(mry_obj);
	register int invalidate_both_caches_flag = !Memory_is_ocm(mry_obj);

	// Start the core's APM to count clock cycles.
	dsb();
	Arm_Counts_start(acs_obj);

	// For memory regions whose configuration is normal and hardware accelerators
	// without cache-coherency, the corresponding cache region must be invalidiated
	// so that cache misses cause the correct data to be loaded.
	if (invalidate_cache_flag) {
		if (invalidate_both_caches_flag) {
			Xil_DCacheInvalidateRange((unsigned int)write_address,transfer_size);
		} else {
			Xil_L1DCacheInvalidateRange((unsigned int)write_address,transfer_size);
		}
	}

	// Read the data from the location to where the hardware accelerator wrote.
	memcpy(buffer,write_address,transfer_size);

	// Stop the core's APM to record the number of clock cycles needed
	// to perform the read operation.
	dsb();
	Arm_Counts_end_total_read(acs_obj);

	// Check whether the data is correct or not.
	for (i=0;i<transfer_size/Hardware_Accelerator_BYTES_PER_32b_WORD;i++) {
		if ((((u32*)buffer)[i])!=(((u32*)read_address)[i])) {
			hde_obj->is_error_flag = 1;
			break;
		}
	}

	// Free buffer
	free(buffer);
}

void Hardware_set_is_cache_coherent_flag(Hardware* hde_obj,int is_cache_coherent_flag) {
	hde_obj->is_cache_coherent_flag = is_cache_coherent_flag;
	//Hardware_Accelerator_set_write_coherent_flag(&hde_obj->hae_obj,is_cache_coherent_flag);
	//Hardware_Accelerator_set_read_coherent_flag(&hde_obj->hae_obj,is_cache_coherent_flag);
}

void Synch_setup(Synch* syn_obj,int pin_run_operation,u32 interrupt_id,Task* tsk_obj) {

	syn_obj->pin_run_operation = pin_run_operation;
	syn_obj->interrupt_id = interrupt_id;
	syn_obj->tsk_obj = tsk_obj;

	IO_WRITE_LOW(pin_run_operation);
	IO_DIRECTION_OUT(pin_run_operation);

	Arm_Counts_setup(&syn_obj->acs_obj);

	XScuGic_Connect_sc(interrupt_id,Synch_interrupt_handler,syn_obj);
	XScuGic_SetPriorityTriggerType_sc(interrupt_id,IO_INTERRUPT_PRIORITY,XSCUGIC_SC_TRIGGER_RISING_EDGE);
}

void Synch_run_operation_handler(Synch* syn_obj) {
	XScuGic_Enable_sc(syn_obj->interrupt_id);	// Enable interrupt associated with global ready.
	dsb();										// Ensure all prior memory operations are completed.
	Arm_Counts_start(&syn_obj->acs_obj);		// Start counter for measuring duration.
	IO_WRITE_HIGH(syn_obj->pin_run_operation);	// Start the operation by raising the global enable.
	Task_sleep(syn_obj->tsk_obj);				// Sleep the task.
}

void Synch_interrupt_handler(void* param) {

	Synch* syn_obj = (Synch*)param;
	BaseType_t xHigherPriorityTaskWoken;

	dsb();														// Ensure all prior memory operations are completed.
	Arm_Counts_end_total(&syn_obj->acs_obj);					// Record the number of clock cycles that passed.
	IO_WRITE_LOW(syn_obj->pin_run_operation);					// Lower global enable.
	XScuGic_Disable_sc(syn_obj->interrupt_id);					// Disable the interrupt associated with the global ready.
	Task_wake_isr(syn_obj->tsk_obj,&xHigherPriorityTaskWoken);	// Wake the main thread.
	portYIELD_FROM_ISR(xHigherPriorityTaskWoken);				// Cooperatively yield cpu to task.
}

void Task_setup(Task* tsk_obj,TaskFuncHandle_t func,void* param,char* string) {
	tsk_obj->sync_hdl = xSemaphoreCreateBinary();
	tsk_obj->lock_hdl = xSemaphoreCreateMutex();
	xTaskCreate_sc(&tsk_obj->task_hdl,func,param,string);
}

int Task_lock(Task* tsk_obj) {
	BaseType_t result;
	if (xTaskGetCurrentTaskHandle()==tsk_obj->task_hdl) {
		result = xSemaphoreTake(tsk_obj->lock_hdl,portMAX_DELAY);
	} else {
		result = xSemaphoreTake(tsk_obj->lock_hdl,0);
	}
	return result==pdTRUE;
}

void Task_unlock(Task* tsk_obj) {
	xSemaphoreGive(tsk_obj->lock_hdl);
}

void Task_sleep(Task* tsk_obj) {
	configASSERT(xTaskGetCurrentTaskHandle()==tsk_obj->task_hdl);
	xSemaphoreTake(tsk_obj->sync_hdl,portMAX_DELAY);
}

void Task_wake(Task* tsk_obj) {
	configASSERT(xTaskGetCurrentTaskHandle()!=tsk_obj->task_hdl);
	xSemaphoreGive(tsk_obj->sync_hdl);
}

void Dummy_Task_setup(Dummy_Task* dmy_obj,Params* prs_obj,int identifier,char* string) {

	dmy_obj->string = string;
	dmy_obj->is_enabled_flag = 0;
	dmy_obj->is_error_flag = 0;
	dmy_obj->is_powersave_flag = 0;
	dmy_obj->lfsr = DUMMY_TASK_LFSR_SEED;

	Task_setup(&dmy_obj->tsk_obj,Dummy_Task_task,dmy_obj,string);

	Dummy_Task_set_identifier(dmy_obj,identifier);
	Dummy_Task_set_location(dmy_obj,identifier);
	Dummy_Task_Params_set_burst_len(dmy_obj,prs_obj->burst_len);
	Dummy_Task_Params_set_transfer_size(dmy_obj,prs_obj->transfer_size);
	Dummy_Task_Params_set_memory(dmy_obj,prs_obj->mry_obj);
}

u16  Dummy_Task_get_uniform_random_value(Dummy_Task* dmy_obj) {

	u16 lsb;
	u16 start_state = dmy_obj->lfsr;

	do {
		lsb = dmy_obj->lfsr & 1;
		dmy_obj->lfsr >>= 1;
		if (lsb == 1)
			dmy_obj->lfsr ^= 0xB400u;
	} while (dmy_obj->lfsr == start_state);

	return dmy_obj->lfsr;
}

int Dummy_Task_set_is_enabled_flag(Dummy_Task* dmy_obj, int is_enabled_flag) {
	if ((is_enabled_flag!=0)==Dummy_Task_is_enabled(dmy_obj))
		return 0;
	if (is_enabled_flag) {
		dmy_obj->is_enabled_flag = 1;
		Task_wake(&dmy_obj->tsk_obj);
	} else {
		dmy_obj->is_enabled_flag = 0;
		while (!Task_lock(&dmy_obj->tsk_obj))
			continue;
		Task_unlock(&dmy_obj->tsk_obj);
	}
	return 1;
}

int Dummy_Task_set_identifier(Dummy_Task* dmy_obj, int identifier) {
	int result = 0;
	if (Task_lock(&dmy_obj->tsk_obj)) {
		result = 1;
		dmy_obj->identifier = identifier;
		Task_unlock(&dmy_obj->tsk_obj);
	}
	return result;
}

int Dummy_Task_set_location(Dummy_Task* dmy_obj, int location) {
	int result = 0;
	if (Task_lock(&dmy_obj->tsk_obj)) {
		result = 1;
		dmy_obj->location = location;
		Task_unlock(&dmy_obj->tsk_obj);
	}
	return result;
}

int Dummy_Task_set_powersave_flag(Dummy_Task* dmy_obj, int is_powersave_flag) {
	int result = 0;
	if (Task_lock(&dmy_obj->tsk_obj)) {
		result = 1;
		dmy_obj->is_powersave_flag = is_powersave_flag;
		Task_unlock(&dmy_obj->tsk_obj);
	}
	return result;
}

int Dummy_Task_Params_set_burst_len(Dummy_Task* dmy_obj, int burst_len) {
	int result = 0;
	if (Task_lock(&dmy_obj->tsk_obj)) {
		result = 1;
		Params_set_burst_len(&dmy_obj->prs_obj,burst_len);
		Task_unlock(&dmy_obj->tsk_obj);
	}
	return result;
}

int Dummy_Task_Params_set_transfer_size(Dummy_Task* dmy_obj, int transfer_size) {
	int result = 0;
	if (Task_lock(&dmy_obj->tsk_obj)) {
		result = 1;
		Params_set_transfer_size(&dmy_obj->prs_obj,transfer_size);
		Task_unlock(&dmy_obj->tsk_obj);
	}
	return result;
}

int Dummy_Task_Params_set_memory(Dummy_Task* dmy_obj, Memory* mry_obj) {
	int result = 0;
	if (Task_lock(&dmy_obj->tsk_obj)) {
		result = 1;
		Params_set_memory(&dmy_obj->prs_obj,mry_obj);
		Task_unlock(&dmy_obj->tsk_obj);
	}
	return result;
}

void Dummy_Task_task(void* param) {

	Dummy_Task* dmy_obj = (Dummy_Task*)param;
	Params* prs_obj = &dmy_obj->prs_obj;
	Task* tsk_obj = &dmy_obj->tsk_obj;
	u32* write_address;
	u32* write_end;
	u32* write_ptr;
	u32* read_address;
	u32* read_end;
	u32* read_ptr;
	int transfer_size_words;
	int bits_amount;
	int offset;
	int i;
	register const int* is_enabled_flag = &dmy_obj->is_enabled_flag;

	// This loop should run indefinitely.
	while (1) {

		// The dummy task should sleep until told to wake up!
		Task_sleep(tsk_obj);

		// Lock the parameters.
		Task_lock(tsk_obj);

		// Configure the data based on the local parameters.
		transfer_size_words = Params_get_transfer_size(prs_obj)/sizeof(u32);
		write_address = Dummy_Task_Params_get_write_address(dmy_obj);
		write_end = write_address+transfer_size_words;
		read_address = Dummy_Task_Params_get_read_address(dmy_obj);
		read_end = read_address+transfer_size_words;

		// Perform assertions.
		Xil_AssertVoid((((long)write_address%sizeof(u32))==0)&&(((long)read_address%sizeof(u32))==0));
		Xil_AssertVoid(transfer_size_words>Params_get_burst_len(prs_obj));
		Xil_AssertVoid(Params_get_burst_len(prs_obj)>0);
		Xil_AssertVoid((write_address<read_address)?(write_end<=read_address):(read_end<=write_address));

		// Generate the data.
		for (i=0;i<Params_get_transfer_size(prs_obj)/Hardware_Accelerator_BYTES_PER_32b_WORD;i++) {
			read_address[i] = i;	// data that's generated is really simple; no reason for anything complex
		}

		// Write the data to the location from where the dummy task will read.
		memset(write_address,0,Params_get_transfer_size(prs_obj));

		// Check whether or not the dummy task should go into powersave mode.
		if (Dummy_Task_get_is_powersave_flag(dmy_obj)) {

			// Spin on the wait-for-event instruction so that power is saved
			// and fewer instructions are read from memory.
			while (*is_enabled_flag) {
				__asm__ __volatile__ ("WFE" : : : "memory" );
			}

		// Perform operation based on the selected operation mode.
		} else {
			Xil_AssertVoid(!(transfer_size_words&(transfer_size_words-1)));
			for (bits_amount = 0;
					transfer_size_words;
					bits_amount++,transfer_size_words>>=1)
				continue;
			bits_amount = (sizeof(u16)<<3)-bits_amount+1;
			while (*is_enabled_flag) {
				offset = Dummy_Task_get_uniform_random_value(dmy_obj)>>bits_amount;
				read_ptr=read_address+offset;
				offset = Dummy_Task_get_uniform_random_value(dmy_obj)>>bits_amount;
				write_ptr=write_address+offset;
				*write_ptr = *read_ptr;
			}
		}

		// Finally, unlock the parameters.
		Task_unlock(tsk_obj);
	}

	// This task should never reach this statement
	vTaskDelete(NULL);
}

void Shared_setup(Shared* shd_obj, void* base_address, u32 domain, void* cpu_1_address,
		u32 self_interrupt_id, u32 other_interrupt_id,  Task* tsk_obj) {

	Shared_Data* shared_data;

	// The shared memory has to be normally ordered so that unaligned memory accesses
	// are allowable.
	Amp_setPageTable2(Amp_write_back_write_allocate,Amp_write_back_write_allocate,
			base_address,domain);

	// Set data.
	shd_obj->shared_data = (Shared_Data*)base_address;
	shd_obj->self_interrupt_id = self_interrupt_id;
	shd_obj->other_interrupt_id = other_interrupt_id;
	shd_obj->tsk_obj = tsk_obj;

	// Connect interrupt.
	XScuGic_Connect_sc(self_interrupt_id,Shared_interrupt_handler,shd_obj);

#if (CPU_DISABLE==0)

	// Run instructions particular to cpu 0.
#if XPAR_CPU_ID==0
	shared_data = shd_obj->shared_data;
	memset(shared_data->message_in,0,sizeof(char)*CPU_MESSAGE_LENGTH);
	memset(shared_data->message_out,0,sizeof(char)*CPU_MESSAGE_LENGTH);
	Amp_cpu_1_start(cpu_1_address);
#endif

	// Run instructions particular to cpu 1.
#if XPAR_CPU_ID==1
	Amp_cpu_1_ready();
#endif

#endif
}

void Shared_interrupt_handler(void* ref) {
	Shared* shd_obj = (Shared*)ref;
	XScuGic_Disable_sc(shd_obj->self_interrupt_id);
	Task_wake(shd_obj->tsk_obj);
}

// It is extremely important to note the id for the first cpu (i.e. cpu 0) is actually
// 1, whereas the id for the second cpu (i.e. cpu 1) is actually 2.
void Shared_signal(Shared* shd_obj) {
	Xil_DCacheFlushRange((unsigned int)shd_obj->shared_data,sizeof(Shared_Data));
	XScuGic_Enable_sc(shd_obj->other_interrupt_id);	// This line might not be necessary.
#if XPAR_CPU_ID==0
	XScuGic_SoftwareIntr_sc(shd_obj->other_interrupt_id,2);	// Send interrupt to cpu 1.
#endif
#if XPAR_CPU_ID==1
	XScuGic_SoftwareIntr_sc(shd_obj->other_interrupt_id,1);	// Send interrupt to cpu 0.
#endif
}

void Shared_wait(Shared* shd_obj) {
	Task_sleep(shd_obj->tsk_obj);
	Xil_DCacheInvalidateRange((unsigned int)shd_obj->shared_data,sizeof(Shared_Data));
}

void Shared_forward_command(Shared* shd_obj, const char* message_in, char* message_out, int message_out_total_size) {

	Shared_Data* shared_data = shd_obj->shared_data;
	char* shared_message_in = shared_data->message_in;
	char* shared_message_out = shared_data->message_out;

	Xil_AssertVoid((strlen(message_in)+1)<CPU_MESSAGE_LENGTH);							// Check and make sure there is enough space in shared buffer.
	strcpy(shared_message_in,message_in);												// Copy input message into shared buffer.
	strcat(shared_message_in,"\n");														// Commands are only completed with the newline character.
	Shared_signal(shd_obj);																// Send interrupt to cpu 1, signaling data is available.
	Shared_wait(shd_obj);																// Wait until the command has been processed.
	Xil_AssertVoid(strlen(shared_message_out)<message_out_total_size);					// Check and make sure there is sufficient space in buffer.
	strcpy(message_out,shared_message_out);												// Copy output message into buffer.
	shared_message_out[0] = '\0';														// Reset output shared buffer.
}

int Main_request_operation() {
	int result = 0;
	if (Task_lock(&tsk_obj)) {
		result = 1;
		Task_wake(&tsk_obj);
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_hardware_enable(int hardware_identifier, int is_enabled_flag) {
	int i;
	int result = 0;
	Hardware* hde_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<HA_TOTAL;i++) {
			hde_obj = &hde_objs[i];
			if (Hardware_get_identifier(hde_obj)==hardware_identifier) {
				result = 1;
				Hardware_set_is_enabled_flag(hde_obj,is_enabled_flag);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_hardware_location(int hardware_identifier, int location) {
	int i;
	int result = 0;
	Hardware* hde_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<HA_TOTAL;i++) {
			hde_obj = &hde_objs[i];
			if (Hardware_get_identifier(hde_obj)==hardware_identifier) {
				result = 1;
				Hardware_set_location(hde_obj,location);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_hardware_params_burst_len(int hardware_identifier, int burst_len) {
	int i;
	int result = 0;
	Hardware* hde_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<HA_TOTAL;i++) {
			hde_obj = &hde_objs[i];
			if (Hardware_get_identifier(hde_obj)==hardware_identifier) {
				result = 1;
				Hardware_Params_set_burst_len(hde_obj,burst_len);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_hardware_params_transfer_size(int hardware_identifier, int transfer_size) {
	int i;
	int result = 0;
	Hardware* hde_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<HA_TOTAL;i++) {
			hde_obj = &hde_objs[i];
			if (Hardware_get_identifier(hde_obj)==hardware_identifier) {
				result = 1;
				Hardware_Params_set_transfer_size(hde_obj,transfer_size);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_hardware_params_operation_mode(int hardware_identifier, int haom) {
	/* Operation mode was removed so this function will
	always return 1 to avoid compatibility issues. */
	return 1;
}

int Main_set_hardware_params_memory(int hardware_identifier, int memory_identifier) {
	int i;
	int result = 0;
	Hardware* hde_obj = NULL;
	Memory* mry_obj = NULL;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<HA_TOTAL;i++) {
			hde_obj = &hde_objs[i];
			if (Hardware_get_identifier(hde_obj)==hardware_identifier) {
				break;
			}
		}
		for (i=0;i<MEMORY_TOTAL;i++) {
			mry_obj = &mry_objs[i];
			if (Memory_get_identifier(mry_obj)==memory_identifier) {
				break;
			}
		}
		if ((hde_obj!=NULL)&&(mry_obj!=NULL)) {
			result = 1;
			Hardware_Params_set_memory(hde_obj,mry_obj);
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_hardware_cache_coherent(int hardware_identifier, int is_cache_coherent_flag) {
	int i;
	int result = 0;
	Hardware* hde_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<HA_TOTAL;i++) {
			hde_obj = &hde_objs[i];
			if (Hardware_get_identifier(hde_obj)==hardware_identifier) {
				result = 1;
				Hardware_set_is_cache_coherent_flag(hde_obj,is_cache_coherent_flag);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

const Hardware* Main_get_hardware(int hardware_identifier) {

	int i;
	Hardware* hde_obj;

	for (i=0;i<HA_TOTAL;i++) {
		hde_obj = &hde_objs[i];
		if (Hardware_get_identifier(hde_obj)==hardware_identifier) {
			return hde_obj;
		}
	}
	return NULL;
}

int Main_set_memory_policies(int memory_identifier, int policy_0, int policy_1) {
	int i;
	int result = 0;
	Memory* mry_obj = NULL;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<MEMORY_TOTAL;i++) {
			mry_obj = &mry_objs[i];
			if (Memory_get_identifier(mry_obj)==memory_identifier) {
				result = 1;
				Memory_set_policies(mry_obj,(Amp_PageAttribute)policy_0,(Amp_PageAttribute)policy_1);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_memory_transfer_size(int memory_identifier, int transfer_size) {
	int i;
	int result = 0;
	Memory* mry_obj = NULL;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<MEMORY_TOTAL;i++) {
			mry_obj = &mry_objs[i];
			if (Memory_get_identifier(mry_obj)==memory_identifier) {
				result = 1;
				Memory_set_max_transfer_size(mry_obj,transfer_size);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

const Memory* Main_get_memory(int memory_identifier) {

	int i;
	Memory* mry_obj;

	for (i=0;i<MEMORY_TOTAL;i++) {
		mry_obj = &mry_objs[i];
		if (Memory_get_identifier(mry_obj)==memory_identifier) {
			return mry_obj;
		}
	}

	return NULL;
}

const Synch* Main_get_synch() {
	return &syn_obj;
}

int Main_set_dummy_task_enable(int dummy_task_identifier, int is_enabled_flag) {

	int i;
	int result = 0;
	Dummy_Task* dmy_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<DUMMY_TASK_TOTAL;i++) {
			dmy_obj = &dmy_objs[i];
			if (Dummy_Task_get_identifier(dmy_obj)==dummy_task_identifier) {
				result = 1;
				Dummy_Task_set_is_enabled_flag(dmy_obj,is_enabled_flag);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_dummy_task_powersave(int dummy_task_identifier, int is_powersave_flag) {

	int i;
	int result = 0;
	Dummy_Task* dmy_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<DUMMY_TASK_TOTAL;i++) {
			dmy_obj = &dmy_objs[i];
			if (Dummy_Task_get_identifier(dmy_obj)==dummy_task_identifier) {
				result = 1;
				Dummy_Task_set_powersave_flag(dmy_obj,is_powersave_flag);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_dummy_task_identifier(int dummy_task_identifier, int identifier) {

	int i;
	int result = 0;
	Dummy_Task* dmy_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<DUMMY_TASK_TOTAL;i++) {
			dmy_obj = &dmy_objs[i];
			if (Dummy_Task_get_identifier(dmy_obj)==dummy_task_identifier) {
				result = Dummy_Task_set_identifier(dmy_obj,identifier);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_dummy_task_location(int dummy_task_identifier, int location) {

	int i;
	int result = 0;
	Dummy_Task* dmy_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<DUMMY_TASK_TOTAL;i++) {
			dmy_obj = &dmy_objs[i];
			if (Dummy_Task_get_identifier(dmy_obj)==dummy_task_identifier) {
				result = Dummy_Task_set_location(dmy_obj,location);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_dummy_task_params_burst_len(int dummy_task_identifier, int burst_len) {

	int i;
	int result = 0;
	Dummy_Task* dmy_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<DUMMY_TASK_TOTAL;i++) {
			dmy_obj = &dmy_objs[i];
			if (Dummy_Task_get_identifier(dmy_obj)==dummy_task_identifier) {
				result = Dummy_Task_Params_set_burst_len(dmy_obj,burst_len);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_dummy_task_params_transfer_size(int dummy_task_identifier, int transfer_size) {

	int i;
	int result = 0;
	Dummy_Task* dmy_obj;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<DUMMY_TASK_TOTAL;i++) {
			dmy_obj = &dmy_objs[i];
			if (Dummy_Task_get_identifier(dmy_obj)==dummy_task_identifier) {
				result = Dummy_Task_Params_set_transfer_size(dmy_obj,transfer_size);
				break;
			}
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_dummy_task_params_operation_mode(int dummy_task_identifier, int haom) {
	/* This function will always return 1 to avoid compatibility issues. */
	return 1;
}

int Main_set_dummy_task_params_memory(int dummy_task_identifier, int memory_identifier) {

	int i;
	int result = 0;
	Memory* mry_obj = NULL;
	Dummy_Task* dmy_obj = NULL;
	if (Task_lock(&tsk_obj)) {
		for (i=0;i<DUMMY_TASK_TOTAL;i++) {
			if (Dummy_Task_get_identifier(&dmy_objs[i])==dummy_task_identifier) {
				dmy_obj = &dmy_objs[i];
				break;
			}
		}
		for (i=0;i<MEMORY_TOTAL;i++) {
			mry_obj = &mry_objs[i];
			if (Memory_get_identifier(&mry_objs[i])==memory_identifier) {
				mry_obj = &mry_objs[i];
				break;
			}
		}
		if ((mry_obj!=NULL)&&(dmy_obj!=NULL)) {
			result = Dummy_Task_Params_set_memory(dmy_obj,mry_obj);
		}
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_set_configure_smp(int is_smp_flag) {

	int result = 0;
	if (Task_lock(&tsk_obj)) {
		vTaskSuspendAll();
		Amp_set_actlr_smp(is_smp_flag);
		xTaskResumeAll();
		result = 1;
		Task_unlock(&tsk_obj);
	}
	return result;
}

int Main_get_hardware_identifier(char* string) {

	int i;
	Hardware* hde_obj;

	for (i=0;i<HA_TOTAL;i++) {
		hde_obj = &hde_objs[i];
		if (!strcmp(string,Hardware_get_string(hde_obj))) {
			return Hardware_get_identifier(hde_obj);
		}
	}
	return -1;
}

int Main_get_memory_identifier(char* string) {

	int i;
	Memory* mry_obj;

	for (i=0;i<MEMORY_TOTAL;i++) {
		mry_obj = &mry_objs[i];
		if (!strcmp(string,Memory_get_string(mry_obj))) {
			return Memory_get_identifier(mry_obj);
		}
	}
	return -1;
}

int Main_get_dummy_task_identifier(char* string) {

	int i;
	Dummy_Task* dmy_obj;

	for (i=0;i<DUMMY_TASK_TOTAL;i++) {
		dmy_obj = &dmy_objs[i];
		if (!strcmp(string,Dummy_Task_get_string(dmy_obj))) {
			return Dummy_Task_get_identifier(dmy_obj);
		}
	}
	return -1;
}

const Dummy_Task* Main_get_dummy_task(int dummy_task_identifier) {

	int i;
	Dummy_Task* dmy_obj;

	for (i=0;i<DUMMY_TASK_TOTAL;i++) {
		dmy_obj = &dmy_objs[i];
		if (Dummy_Task_get_identifier(dmy_obj)==dummy_task_identifier) {
			return dmy_obj;
		}
	}
	return NULL;
}

void Main_configure_memory() {
	///// OCM
	Memory_setup(&mry_objs[MEMORY_OCM_ID],MEMORY_OCM_ID,(void*)MEMORY_OCM_BASE_ADDRESS,HA_MAX_TANSFER_SIZE,
			MEMORY_OCM_DOMAIN,MEMORY_OCM_IS_OCM_FLAG,MEMORY_OCM_POLICY_0,MEMORY_OCM_POLICY_1,MEMORY_OCM_STRING);
	///// DDR
	Memory_setup(&mry_objs[MEMORY_DDR_ID],MEMORY_DDR_ID,(void*)MEMORY_DDR_BASE_ADDRESS,HA_MAX_TANSFER_SIZE,
			MEMORY_DDR_DOMAIN,MEMORY_DDR_IS_OCM_FLAG,MEMORY_DDR_POLICY_0,MEMORY_DDR_POLICY_1,MEMORY_DDR_STRING);
}

void Main_configure_dummy_tasks() {
	Params prs_obj;
	prs_obj.burst_len = DUMMY_TASK_PARAMS_BURST_LEN;
	prs_obj.transfer_size = DUMMY_TASK_PARAMS_TRANSFER_SIZE;
	prs_obj.mry_obj = DUMMY_TASK_PARAMS_MEMORY;
	Dummy_Task_setup(&dmy_objs[0],&prs_obj,DUMMY_TASK_0_ID,DUMMY_TASK_0_STRING);
}

#if XPAR_CPU_ID==0

void task(void* param) {

	int i;

	Task* tsk_obj = (Task*)param;
	Hardware* hde_obj;
	Params prs_obj;

	// Once the main task is started, a number of operations
	// need to take place prior to any operation.

	//// Let's lock the task so as to prevent any interference,
	//// specifically from the console. This is most likely
	//// unnecessary since the creation of the task that handles
	//// the console, from experimentation, doesn't seem to ever
	//// occur until the main task sleeps.
	Task_lock(tsk_obj);

	//// Store the handler to the generic interrupt controller. This line should
	//// appear prior to any setup functions that require usage of interrupts.
	XScuGic_setXScuGic_sc(&xInterruptController);

	//// Set up asymmetric mode of operation.
	////// Prepare shared memory between cpus.
	Shared_setup(&shd_obj,(void*)CPU_SHARE_ADDRESS,CPU_DOMAIN,
			(void*)CPU_1_ADDRESS,CPU_0_INT_ID,CPU_1_INT_ID,tsk_obj);

	//// Configure the input and output via the extended multiplexed
	//// input/output.
	XGpioPs_setup_sc(&emio_obj,IO_ID);

	//// Configure the memory
	Memory_static_setup();
	Main_configure_memory();

	//// Configure the hardware
	////// Sync
	Synch_setup(&syn_obj,IO_RUN_OPERATION,IO_INT_ID,tsk_obj);
	////// Default Parameters
	prs_obj.burst_len = HA_PARAMS_BURST_LEN;
	prs_obj.transfer_size = HA_PARAMS_TRANSFER_SIZE;
	prs_obj.mry_obj = HA_PARAMS_MEMORY;
	////// ACP
	Hardware_setup(&hde_objs[HA_ACP_0_HAS_ID],&prs_obj,
			HA_ACP_0_HAS_ID,HA_ACP_0_IO_RUN_OPERATION,HA_ACP_0_IS_CONNECTED_TO_ACP_FLAG,
			HA_ACP_0_IS_64b_FLAG,HA_ACP_0_IS_CACHE_COHERENT_FLAG,HA_ACP_0_INT_ID,
			(void*)HA_ACP_0_M_AXI_BASE_ADDRESS,(void*)HA_ACP_0_PERFORM_BASE_ADDRESS,
			HA_ACP_0_STRING);
//	Hardware_setup(&hde_objs[HA_ACP_1_HAS_ID],&prs_obj,
//			HA_ACP_1_HAS_ID,HA_ACP_1_IO_RUN_OPERATION,HA_ACP_1_IS_CONNECTED_TO_ACP_FLAG,
//			HA_ACP_1_IS_64b_FLAG,HA_ACP_1_IS_CACHE_COHERENT_FLAG,HA_ACP_1_INT_ID,
//			(void*)HA_ACP_1_M_AXI_BASE_ADDRESS,(void*)HA_ACP_1_PERFORM_BASE_ADDRESS,
//			HA_ACP_1_STRING);
//	////// GP0
//	Hardware_setup(&hde_objs[HA_GP0_0_HAS_ID],&prs_obj,
//			HA_GP0_0_HAS_ID,HA_GP0_0_IO_RUN_OPERATION,HA_GP0_0_IS_CONNECTED_TO_ACP_FLAG,
//			HA_GP0_0_IS_64b_FLAG,HA_GP0_0_IS_CACHE_COHERENT_FLAG,HA_GP0_0_INT_ID,
//			(void*)HA_GP0_0_M_AXI_BASE_ADDRESS,(void*)HA_GP0_0_PERFORM_BASE_ADDRESS,
//			HA_GP0_0_STRING);
//	////// HP0-2
//	Hardware_setup(&hde_objs[HA_HP0_0_HAS_ID],&prs_obj,
//			HA_HP0_0_HAS_ID,HA_HP0_0_IO_RUN_OPERATION,HA_HP0_0_IS_CONNECTED_TO_ACP_FLAG,
//			HA_HP0_0_IS_64b_FLAG,HA_HP0_0_IS_CACHE_COHERENT_FLAG,HA_HP0_0_INT_ID,
//			(void*)HA_HP0_0_M_AXI_BASE_ADDRESS,(void*)HA_HP0_0_PERFORM_BASE_ADDRESS,
//			HA_HP0_0_STRING);
//	Hardware_setup(&hde_objs[HA_HP1_0_HAS_ID],&prs_obj,
//			HA_HP1_0_HAS_ID,HA_HP1_0_IO_RUN_OPERATION,HA_HP1_0_IS_CONNECTED_TO_ACP_FLAG,
//			HA_HP1_0_IS_64b_FLAG,HA_HP1_0_IS_CACHE_COHERENT_FLAG,HA_HP1_0_INT_ID,
//			(void*)HA_HP1_0_M_AXI_BASE_ADDRESS,(void*)HA_HP1_0_PERFORM_BASE_ADDRESS,
//			HA_HP1_0_STRING);
//	Hardware_setup(&hde_objs[HA_HP2_0_HAS_ID],&prs_obj,
//			HA_HP2_0_HAS_ID,HA_HP2_0_IO_RUN_OPERATION,HA_HP2_0_IS_CONNECTED_TO_ACP_FLAG,
//			HA_HP2_0_IS_64b_FLAG,HA_HP2_0_IS_CACHE_COHERENT_FLAG,HA_HP2_0_INT_ID,
//			(void*)HA_HP2_0_M_AXI_BASE_ADDRESS,(void*)HA_HP2_0_PERFORM_BASE_ADDRESS,
//			HA_HP2_0_STRING);

	//// Configure dummy tasks.
	Main_configure_dummy_tasks();

	//// Configure the console for transmitting and receiving
	//// messages over the UART.
	Cli_setup(&shd_obj);

	//// Set the callback handler for failed assertions. Since this uses
	//// the uart, the Cli must be configured prior to this point.
	Xil_AssertSetCallback(asset_callback);

	//// Now that the application has been fully configured, the
	//// the task can be unlocked so that the console can perform
	//// operations
	Task_unlock(tsk_obj);

	// It is worth noting no messages can be transmitted to the console at this point since
	// the task that configures the console doesn't start until this task begins
	// to sleep.

	// Now the following loop runs indefinitely.
	while (1) {

		// Sleep until the user of the application decides to initiate
		// the application's main operation. The number of cycles for which the
		// task sleeps is also recorded to determine the amount of delay between
		// each request to start the operation.
		Synch_Arm_Counts_start(&syn_obj);
		Task_sleep(tsk_obj);
		Synch_Arm_Counts_end_sleep(&syn_obj);

		// When woken up, lock all the resources so as to prevent the console
		// from changing data being utilized.
		Task_lock(tsk_obj);

		// Check and see whether any hardware accelerators are
		// enabled
		for (i=0;i<HA_TOTAL;i++) {
			if (Hardware_is_enabled(&hde_objs[i])) {
				goto task_JUMP_1;
			}
		}
		UART_PRINT("There are no hardware accelerators selected...");
		goto task_JUMP_0;
		task_JUMP_1:

		// Let the user know the operation has begun.
		UART_PRINT("The operation has begun...");

		// Clear state of system by flushing both DL1- and L2-caches,
		// invalidating cache for translation lookaside buffer,
		// and invalidating cache for branch target prediction.
		vTaskSuspendAll();
		mtcp(XREG_CP15_INVAL_UTLB_UNLOCKED, 0);
		mtcp(XREG_CP15_INVAL_BRANCH_ARRAY, 0);
		Xil_DCacheFlush();
		xTaskResumeAll();

		// Configure each enabled hardware accelerator
		for (i=0;i<HA_TOTAL;i++) {
			hde_obj = &hde_objs[i];
			if (Hardware_is_enabled(hde_obj)) {
				Hardware_Monitor_reset(hde_obj);
				Hardware_Params_configure(hde_obj);
				Hardware_operation_generate(hde_obj);
				Hardware_run_operation(hde_obj);
			}
		}

		// Run operation.
		//// Know that this function causes the main thread to sleep
		//// until the completion of the operation.
		Synch_run_operation_handler(&syn_obj);

		// Check for any errors and send reports.
		for (i=0;i<HA_TOTAL;i++) {
			hde_obj = &hde_objs[i];
			if (Hardware_is_enabled(hde_obj)) {
				Hardware_operation_check(hde_obj);
				Hardware_Monitor_load(hde_obj);
			}
		}

		// Report to user the operation is finished.
		UART_PRINT("The operation has completed...");

		// This label indicates to where the program should jump if the operation
		// needs to finish immediately.
		task_JUMP_0:

		// Once the operation is complete, unlock all the resources so that they
		// can be modified.
		Task_unlock(tsk_obj);

		// Let the user know it's okay to request the next operation.
		Cli_send_finish();
	}

	// This task should never reach this statement
	vTaskDelete(NULL);
}

#elif XPAR_CPU_ID==1

void task(void* param) {

	Task* tsk_obj = (Task*)param;

	// Configure cpu 1.

	//// Store the handler to the generic interrupt controller.
	XScuGic_setXScuGic_sc(&xInterruptController);

	//// Set up asymmetric mode of operation.
	////// Prepare shared memory between cpus.
	Shared_setup(&shd_obj,(void*)CPU_SHARE_ADDRESS,CPU_DOMAIN,
			NULL,CPU_1_INT_ID,CPU_0_INT_ID,tsk_obj);

	//// Configure memory.
	Main_configure_memory();

	//// Configure dummy tasks.
	Main_configure_dummy_tasks();

	//// Set up the virtual command line. Since the virtual command line
	//// requires the shared object for initialization, the shared object
	//// must be created before.
	Clv_setup(&shd_obj);

	// This task is not needed anymore after this point, so
	// it's okay to shut down this task.
	vTaskDelete(NULL);
}

#endif


