/**
* @file ax3_metrics_counter.h
*
* Header file for ax3_metrics_counter.c. The purpose of this driver is to simplify
* the operation of the axi3 metrics counter implemented as programmable logic. The
* axi3 metrics counter was originally created to obtain performance metrics of the
* hardware accelerator, but can be applied to other soft hardware which utilizes
* the full AXI communication protocol as their interface.
*
* It is recommended to be familiar with the ARM AMBA Advanced eXensible interface
* (AXI) to completely understand some of the terminology utilized in this
* documentation. However, some key terms are briefly explained here.
*
* Transaction 	- A single AXI transfer, including control information and data.
* Burst 		- The data transferred during a transaction. Is composed of multiple
* 				  words.
* Word			- The amount of data transferred during a single clock cycle.
* Data width	- The size of the word. Is composed of multiple bytes.
* Device		- Not specifically related to AXI, but just know --- in the context
* 				  of this documentation --- device refers to the hardware implemented
* 				  in programmable logic, specifically hardware that carries out a
* 				  function apart from mitigating communication.
*
* Due to the simplicity of the axi3 metrics counter, there are conditions that must be
* followed.
*
* 				1). No overlapping transactions in the same direction. In other
* 				words, write and read transactions may overlap. Once the master
* 				AXI interface attempts to start a transaction by raising the valid
* 				signal on either its write or read address channels, the axi3
* 				metrics counter will ignore all other high valid signals until
* 				the transaction completes. Counters related to latency of a
* 				transaction will increment every clock cycle during this period.
*
* 				A transaction is considered finished depends on whether a write or
* 				read transaction was issued. The end of a write transaction occurs
* 				when the valid and ready signals on the write response channel are
* 				high, whereas the end of a read transaction occurs when the valid,
* 				ready, and last signals in the read data channel are high.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- ---------------------------------------------------
*       aap  07/2/15 Initial version
*
* </pre>
*
* @note
*
* aap - Andrew Andre Powell of Temple University's College of Engineering
*
******************************************************************************/

#ifndef AXI3_METRICS_COUNTER_H
#define AXI3_METRICS_COUNTER_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"

/*************** Include Files (User Defined) ********/
#include "xil_assert.h"

#define AXI3_METRICS_COUNTER_BYTES_PER_WORD					4	// refers to the AXI Lite interface
#define AXI3_METRICS_COUNTER_REG_CONTROL					(0*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_LATENCY_TOTAL_WRITE		(1*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_LATENCY_TOTAL_READ			(2*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_LATENCY_MIN_WRITE			(3*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_LATENCY_MIN_READ			(4*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_LATENCY_MAX_WRITE			(5*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_LATENCY_MAX_READ			(6*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_COUNTER					(7*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_TRANSACTION_TOTAL_WRITE	(8*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_REG_TRANSACTION_TOTAL_READ		(9*AXI3_METRICS_COUNTER_BYTES_PER_WORD)
#define AXI3_METRICS_COUNTER_MAS_CONTROL_RESET				0x1

/******************* Type Definitions ****************/
#define AXI3_METRICS_COUNTER_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define AXI3_METRICS_COUNTER_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************ Type Definitions (User Defined) ********/

/**
 * All the possible metrics that can be acquired from the
 * axi3 metrics counter.
 */
typedef enum Axi3_Metrics_Counter_Metric {
	Axi3_Metrics_Counter_Metric_LATENCY_TOTAL_WRITE,
	Axi3_Metrics_Counter_Metric_LATENCY_TOTAL_READ,
	Axi3_Metrics_Counter_Metric_LATENCY_MIN_WRITE,
	Axi3_Metrics_Counter_Metric_LATENCY_MIN_READ,
	Axi3_Metrics_Counter_Metric_LATENCY_MAX_WRITE,
	Axi3_Metrics_Counter_Metric_LATENCY_MAX_READ,
	Axi3_Metrics_Counter_Metric_COUNTER,
	Axi3_Metrics_Counter_Metric_TRANSACTION_TOTAL_WRITE,
	Axi3_Metrics_Counter_Metric_TRANSACTION_TOTAL_READ
} Axi3_Metrics_Counter_Metric;

/**
 *
 */
typedef struct Axi3_Metrics_Counter {
	void* base_address;
} Axi3_Metrics_Counter;

/******************* Function Prototypes *************/
/******** Function Prototypes (User Defined) *********/

void Axi3_Metrics_Counter_setup(Axi3_Metrics_Counter* amc,void* base_address);
void Axi3_Metrics_Counter_reset(Axi3_Metrics_Counter* amc);
u32 Axi3_Metrics_Counter_get_metric(Axi3_Metrics_Counter* amc,Axi3_Metrics_Counter_Metric metric);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif // AXI3_METRICS_COUNTER_H
