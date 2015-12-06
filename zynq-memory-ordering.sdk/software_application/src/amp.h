#ifndef AMP_SHORCUTS_H_
#define AMP_SHORCUTS_H_

#include <xil_types.h>
#include <xil_assert.h>
#include <xil_mmu.h>
#include <xil_io.h>
#include <xil_cache.h>

#include <stddef.h>
#include <string.h>

typedef enum Amp_PageAttribute {
	Amp_strongly_ordered,
	Amp_shareable_device,
	Amp_write_through_no_write_allocate,
	Amp_write_back_no_write_allocate,
	Amp_non_cacheable,
	Amp_write_back_write_allocate
} Amp_PageAttribute;

typedef struct Amp_SharedMemory {
	void* address;
	u32 domain;
	Amp_PageAttribute pageAttribute;
} Amp_SharedMemory;

typedef struct Semaphore {
	u32 semaphore;
} Semaphore;

typedef struct SpinLock {
	u32 lock;
} SpinLock;

void* Amp_get_vector_base_address();
void Amp_set_actlr_smp(int smp_flag);
int Amp_get_actlr_smp();
void Amp_cpu_1_start(void* cpu1_start_address);
void Amp_cpu_1_ready();
void Amp_setupPageTableArray(const Amp_SharedMemory* sharedMemories,size_t sharedMemoriesAmount);
void Amp_setPageTable(Amp_PageAttribute pageAttribute,void* address,u32 domain);
void Amp_setPageTable2(Amp_PageAttribute pageAttributeL1,Amp_PageAttribute pageAttributeL2,void* address,u32 domain);

void Semaphore_setup(Semaphore* smp_obj);
void Semaphore_signal(Semaphore* smp_obj);
void Semaphore_wait(Semaphore* smp_obj);

void SpinLock_clear(SpinLock* spinLock);
void SpinLock_lock(SpinLock* spinLock);
void SpinLock_unlock(SpinLock* spinLock);

#endif
