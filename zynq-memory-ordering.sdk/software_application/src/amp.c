#include "amp.h"

static void Xil_EnableMMU_mod();
static void Xil_DisableMMU_mod();

#define CPU1_DEFAULT_DOMAIN					15
#define BASE_INDEX							0
#define ONE_MB								0x100000
#define CPU1STARTADR		 				(0xfffffff0)
#define LOCKED								(u8)1
#define UNLOCKED							(u8)0
#define OCM_ADDRESS							(0xffff0000)
#define SPIN_LOCK_SIZE						4
#define GET_SPIN_LOCK_BASE_ADDRESS(a)		(((u32)(a))+(0*sizeof(AmpTools_Word)))
#define GET_SPIN_LOCK_END_ADDRESS(a)		(GET_SPIN_LOCK_BASE_ADDRESS(a)+(SPIN_LOCK_SIZE*sizeof(AmpTools_Word)))
#define GET_DATA_BASE_ADDRESS(a)			GET_SPIN_LOCK_END_ADDRESS(a)
#define ACTLR_SMP_MASK						(1<<6)
#define sev()								__asm__ __volatile__ ("SEV" : : : "memory" );
#define wfe()								__asm__ __volatile__ ("WFE" : : : "memory" );
#define ldrex(destination,address)			__asm__ __volatile__ ("LDREX %0, [%1]" : "=r" ((destination)) : "r" ((address)) : "memory" )
#define strex(status,source,address)		__asm__ __volatile__ ("STREX %0, %1, [%2]" : "=r" ((status)) : "r" ((source)), "r" ((address)) : "memory" )
#define clrex()								__asm__ __volatile__ ("CLREX" : : : "memory" )
#define read_actlr(destination)				__asm__ __volatile__ ("MRC p15, 0, %0, c1, c0, 1" : "=r" ((destination)) : : "memory")
#define write_actlr(source)					__asm__ __volatile__ ("MCR p15, 0, %0, c1, c0, 1" : : "r" ((source)) : "memory")
#define read_vbar(destination) 				__asm__ __volatile__ ("MRC	p15, 0, %0, c12, c0, 0" : "=r" ((destination)) : : "memory")

void Xil_EnableMMU_mod() {

	u32 Reg;

	Xil_DCacheInvalidate();
	Xil_ICacheInvalidate();

	Reg = mfcp(XREG_CP15_SYS_CONTROL);
	Reg |= 0x05;
	Reg |= 0x800; // Enable branch prediction

	mtcp(XREG_CP15_SYS_CONTROL, Reg);

	dsb();
	isb();
}

void Xil_DisableMMU_mod(void) {

	u32 Reg;

	mtcp(XREG_CP15_INVAL_UTLB_UNLOCKED, 0);
	mtcp(XREG_CP15_INVAL_BRANCH_ARRAY, 0);
	Xil_DCacheFlush();

	Reg = mfcp(XREG_CP15_SYS_CONTROL);
	Reg &= ~0x05;
	Reg &= ~0x800; // Disable branch prediction

	mtcp(XREG_CP15_SYS_CONTROL, Reg);
}

void* Amp_get_vector_base_address() {

	register u32 vbar;

	read_vbar(vbar);
	return (void*)vbar;
}

void Amp_set_actlr_smp(int smp_flag) {

	register u32 actlr;

	// This function is written such that many calls
	// to Amp_set_actlr_smp does not cause the processor
	// to crash. There is a known, albeit unfixed bug with
	// this function. If there are too many calls to
	// either the MMU management functions, the processor
	// will throw an exception. More investigation needs
	// to be done to understand why.

	read_actlr(actlr);
	if (((actlr&ACTLR_SMP_MASK)!=0)!=
			(smp_flag!=0)) {
		actlr = (smp_flag!=0) ?
				(actlr | ACTLR_SMP_MASK) :
				(actlr & ~ACTLR_SMP_MASK);
		Xil_DisableMMU_mod();
		write_actlr(actlr);
		Xil_EnableMMU_mod();
	}
}

int Amp_get_actlr_smp() {

	register u32 actlr;

	read_actlr(actlr);
	return (actlr & ACTLR_SMP_MASK);
}

void Amp_cpu_1_start(void* cpu1_start_address) {

	volatile u32* semaphore = (volatile u32*)OCM_ADDRESS;
	volatile u32* cpu_1_start_address_location = (volatile u32*)CPU1STARTADR;

	// The OCM needs to be configured for strongly-ordered operations.
	Amp_setPageTable(Amp_strongly_ordered,(void*)OCM_ADDRESS,0);

	// Reset semaphore.
	*semaphore = 0;

	// Set cpu 1 start address.
	*cpu_1_start_address_location = (u32)cpu1_start_address;

	// Signal an event to wake up all processors from their slumber (which is only cpu 1)!
	sev();

	// Block on semaphore until cpu 1 is ready for cpu 0 to continue;
	while (*semaphore==0) wfe();
}

void Amp_cpu_1_ready() {

	volatile u32* semaphore = (volatile u32*)OCM_ADDRESS;

	// The OCM needs to be configured for strongly-ordered operations.
	Amp_setPageTable(Amp_strongly_ordered,(void*)OCM_ADDRESS,0);

	// Reset semaphore to let cpu 0 continue its operation.
	sev();
	*semaphore = 1;
}

void Amp_setupPageTableArray(const Amp_SharedMemory* sharedMemories, size_t sharedMemoriesAmount) {

	size_t i;
	const Amp_SharedMemory* sharedMemory;

	Xil_AssertVoid(sharedMemories != NULL);

	for (i = 0; i < sharedMemoriesAmount; i++) {
		sharedMemory = &sharedMemories[i];
		Xil_AssertVoid(sharedMemory != NULL);
		Amp_setPageTable(sharedMemory->pageAttribute, sharedMemory->address,sharedMemory->domain);
	}
}

void Amp_setPageTable(Amp_PageAttribute pageAttribute, void* address,u32 domain) {

	// references
	// setting C=b0, B=b0 causes strongly-ordered memory, and thus atomicity is preserved for all STR and LDRs
	// page 80 http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf
	// http://www.csc.lsu.edu/~whaley/teach/FHPO_F11/ARM/CortAProgGuide.pdf
	// Probably the best source is the ARMv7 Technical Reference manual
	// on page 1326/1367 http://liris.cnrs.fr/~mmrissa/lib/exe/fetch.php?media=armv7-a-r-manual.pdf

	// ns=0
	// ng=0
	// s=1
	// ap=011
	// tex=(defined by pageAttribute) (Type extension bits)
	// domain=current_domain
	// xn=0
	// c=(defined by pageAttribute) (cache-able bit)
	// b=(defined by pageAttribute) (buffer-able bit)
	// 10000110dddd0cb10

	u32 attribute,tex,c,b;

	// Assert on domain
	Xil_AssertVoid(domain<16);

	// Set default attributes
	attribute = 0x10C02;
	// Determine cache and memory configuration
	switch (pageAttribute) {
	case Amp_strongly_ordered: 								tex = 0; c = 0; b = 0; break;
	case Amp_shareable_device:								tex = 0; c = 0; b = 1; break;
	case Amp_write_through_no_write_allocate:				tex = 0; c = 1; b = 0; break;
	case Amp_write_back_no_write_allocate:					tex = 0; c = 1; b = 1; break;
	case Amp_non_cacheable:									tex = 1; c = 0; b = 0; break;
	case Amp_write_back_write_allocate:						tex = 1; c = 1; b = 1; break; // Hmmm, UG585 says differently than the ARM TRM
	default:												Xil_AssertVoidAlways(); break;
	}
	// Set attribute based on desired cache and memory configuration and domain
	attribute |= (tex<<12)|(domain<<5)|(c<<3)|(b<<2);
	// Write configurations to page table
	Xil_SetTlbAttributes((u32)address,attribute);
}

void Amp_setPageTable2(Amp_PageAttribute pageAttributeL1,Amp_PageAttribute pageAttributeL2,void* address,u32 domain) {

	// It should be noted L1, or the inner cache; and L2, or the outer cache; can each
	// have their own respective cache policy. In regards to ACP, some cache policies offer
	// reliable transfer, whereas others do not. More work should be done as to why this is,
	// but for now it will suffice just to know which configurations are viable.

	int i;
	u32 attribute,tex,c,b;
	Amp_PageAttribute attributes[2]={pageAttributeL1,pageAttributeL2};
	u32 policies[2];

	Xil_AssertVoid(domain<16);
	attribute = 0x10C02;
	tex = 4;
	for (i=0;i<2;i++)
		switch (attributes[i]) {
		case Amp_write_through_no_write_allocate:				policies[i] = 2; break;
		case Amp_write_back_no_write_allocate:					policies[i] = 3; break;
		case Amp_non_cacheable:									policies[i] = 0; break;
		case Amp_write_back_write_allocate:						policies[i] = 1; break;
		default:												Xil_AssertVoidAlways(); break;
		}
	tex |= policies[1];
	c = (policies[0]&2)?1:0;
	b = (policies[0]&1)?1:0;
	attribute |= (tex<<12)|(domain<<5)|(c<<3)|(b<<2);
	Xil_SetTlbAttributes((u32)address,attribute);
}

// According to the Zynq TRM, exclusive monitors are only present in the
// L1 (inner) caches. Thus, the normal memory model with at least cacheable
// inner policy must be enabled in order to take advantage of the exclusive monitors.
// See 5.8 of UG585 (Zynq TRM).
// Also note, according to the ARM TRM, the CLREX needs is needed to clear exclusive
// monitors during context switching, in case of a preemptive multi-tasked system.
// Not doing so could potentially lead to interwoven exclusive instructions (e.g. LDREX and STREX)
// and thus race conditions.
// See A3.4 in ARM Technical Manual ARMv7 (ARM TRM).
void Semaphore_setup(Semaphore* smp_obj) {
	smp_obj->semaphore = 0;
}

void Semaphore_signal(Semaphore* smp_obj) {

	// Declare the registers.
	register u32* semaphore_address;
	register int semaphore_value;
	register u32 status;

	// Initialize registers with necessary values.
	semaphore_address = &smp_obj->semaphore;
	status = 1;

	// Atomically raise the value of the semaphore.
	while (status) {
		ldrex(semaphore_value,semaphore_address);
		semaphore_value++;
		strex(status,semaphore_value,semaphore_address);
	}

	// Signal an event if the semaphore is greater than
	// or equal to zero.
	if (semaphore_value>=0) {
		sev();
	}
}

void Semaphore_wait(Semaphore* smp_obj) {

	// Declare the registers.
	register u32* semaphore_address;
	register int semaphore_value;
	register u32 status;

	// Initialize registers with necessary values.
	semaphore_address = &smp_obj->semaphore;
	status = 1;

	// Atomically lower the value of the semaphore.
	while (status) {
		ldrex(semaphore_value,semaphore_address);
		semaphore_value--;
		strex(status,semaphore_value,semaphore_address);
	}

	// To save power, block on a wait for an event.
	// Then, stop blocking if semaphore is greater than
	// or equal to zero.
	do {
		wfe();
		semaphore_value = ldr(semaphore_address);
	} while (semaphore_value<0);
}

/* ARM Cortex A9 General Instruction Set Architecture References */
// https://www.scss.tcd.ie/john.waldron/3d1/QRC0001H_rvct_v2.1_arm.pdf
// http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0068b/CIHEDHIF.html

/* ARM Cortex A9 Memory Barrier References */
// ug585 is also an excellent reference since it covers the entire EPP, including its APU
// http://stackoverflow.com/questions/13148421/do-spinlocks-really-need-dmb
// http://stackoverflow.com/questions/14950614/working-of-asm-volatile-memory
// http://www.codeproject.com/Articles/15971/Using-Inline-Assembly-in-C-C
// page 19
// http://infocenter.arm.com/help/topic/com.arm.doc.genc007826/Barrier_Litmus_Tests_and_Cookbook_A08.pdf

void SpinLock_clear(SpinLock* spinLock) {

	// Clear lock
	spinLock->lock = 0;
}

void SpinLock_lock(SpinLock* spinLock) {
	__asm__ __volatile__(
			"mov		r0, #1			\n" // prepare to store lock value
			"Loop:						\n" // label
			"ldrex		r5, [%0]		\n"	// exclusively read the lock from memory (lock memory)
			"cmp 		r5, #0			\n"	// check if lock is 0
			"wfene						\n"	// sleep if the lock is held
			"strexeq	r5, r0, [%0]	\n" // attempt to store new value (release memory)
			"cmpeq		r5, #0			\n" // test if store succeeded
			"bne		Loop			\n"	// retry if not
			"dmb						\n"	// make sure all previous instructions are called, before continuing
			: : "r" (&spinLock->lock) : "r0", "r5");
}

void SpinLock_unlock(SpinLock* spinLock) {
	__asm__ __volatile__(
			"mov 		r0, #0			\n" // prepare for clearing lock
			"dmb						\n" // make sure all instructions are finished prior to clearing the lock
			"str 		r0, [%0]		\n" // clear the spinlock
			"dsb						\n" // force the other processor to hold off on memory accesses until this processor is finished
			"sev						\n" // in case the other processor is sleeping, signal an event to wake it up
			: : "r" (&spinLock->lock) : "r0");
}
