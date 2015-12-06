/**
* @file PeripheralShortcuts.h
*
* Header file for PeripheralShortcuts.c. The main purpose of PeripheralShortcuts
* is to provide functions and structures to facilitate common operations done in
* the StandAlone operating system.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- ---------------------------------------------------
*       aap  06/26/15 Initial version
*
* </pre>
*
* @note
*
* aap - Andrew Andre Powell of Temple University's College of Engineering
*
******************************************************************************/

#ifndef PERIPHERAL_SHORTCUTS_H_
#define PERIPHERAL_SHORTCUTS_H_

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/****************** Include Files (User Defined)  ********************/

#include <xparameters.h>
#include <xil_types.h>
#include <xil_assert.h>

#ifdef XPAR_XUARTPS_NUM_INSTANCES
#include <xuartps.h>
#endif
#ifdef XPAR_XSCUGIC_NUM_INSTANCES
#include <xscugic.h>
#define XSCUGIC_SC_TRIGGER_RISING_EDGE		0x3
#endif
#ifdef XPAR_XTTCPS_NUM_INSTANCES
#include "xttcps.h"
#endif
#ifdef XPAR_XGPIOPS_NUM_INSTANCES
#include <xgpiops.h>
#endif
#ifdef XPAR_XAXIPMON_NUM_INSTANCES
#include <xaxipmon.h>
#endif
#ifdef XPAR_XGPIO_NUM_INSTANCES
#include <xgpio.h>
#endif

#include <stddef.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>

/**************** Type Definitions (User Defined) ********************/

typedef size_t (*Io_Handle)(void* parent, void* buffer, size_t size);	/**< See struct Io. */
typedef void (*Io_Address_Handle)(void* parent, void* address);			/**< See struct Io. */

/**
 * The Io type is intended to extend the functionality of another object
 * whose purpose is to transmit and receive characters.
 */
typedef struct Io {
	void* parent;						/**< Object whose functionality is extended by Io. */
	Io_Handle writeHandle;				/**< Address to the write function. */
	Io_Handle readHandle;				/**< Address to the read function. */
	Io_Address_Handle addressHandle;	/**< Address to the function to set access address */
} Io;

#ifdef XPAR_XAXIPMON_NUM_INSTANCES

typedef enum XAxiPmon_Direction {
	XAxiPmon_Direction_WRITE,
	XAxiPmon_Direction_READ
} XAxiPmon_Direction;

typedef enum XAxiPmon_Profile_Metric {
	XAxiPmon_Profile_Metric_BYTE_COUNT,
	XAxiPmon_Profile_Metric_TRANSACTION_COUNT,
	XAxiPmon_Profile_Metric_LATENCY_COUNT
} XAxiPmon_Profile_Metric;

#endif

/*************** Function Prototypes (User Defined) ******************/

void Io_setup(Io* io, void* parent,
		Io_Handle writeHandle, Io_Handle readHandle,
		Io_Address_Handle addressHandle);
size_t Io_write(Io* io, void* buffer, size_t size);
void Io_writeChar(Io* io, char character);
void Io_writeChars(Io* io, char character, size_t numberOfChars);
void Io_writeString(Io* io, char* nullTerminatedString);
void Io_writeFormattedString(Io* io, char* nullTerminatedString, ...);
void Io_writeFormattedStringVariadic(Io* io, char* nullTerminatedString,va_list* args);
size_t Io_read(Io* io, void* buffer, size_t size);
size_t Io_readChar(Io* io, char* character);

void Io_setAddress(Io* io, void* address);
size_t Io_writeToAddress(Io* io, void* address, void* buffer, size_t size);
size_t Io_readFromAddress(Io* io, void* address, void* buffer, size_t size);

#ifdef XPAR_XUARTPS_NUM_INSTANCES
void XUartPs_setup_sc(XUartPs* xuartps, Io* io, u16 DeviceId, u32 BaudRate);
#endif
#ifdef XPAR_XSCUGIC_NUM_INSTANCES
void XScuGic_setup_sc(XScuGic* xscugic, u16 DeviceId);	// only use if pure StandAlone OS is being used
void XScuGic_setXScuGic_sc(XScuGic* xscugic);
void XScuGic_Connect_sc(u32 Int_Id, Xil_InterruptHandler Handler, void *CallBackRef);
void XScuGic_Disconnect_sc(u32 Int_Id);
void XScuGic_Enable_sc(u32 Int_Id);
void XScuGic_Disable_sc(u32 Int_Id);
void XScuGic_SetPriorityTriggerType_sc(u32 Int_Id, u8 Priority, u8 Trigger);
void XScuGic_GetPriorityTriggerType_sc(u32 Int_Id, u8 *Priority, u8 *Trigger);
void XScuGic_SoftwareIntr_sc(u32 Int_Id, u32 Cpu_Id);
#endif
#ifdef XPAR_XTTCPS_NUM_INSTANCES
void XTtcPs_setup_sc(XTtcPs* xttcps, u16 DeviceId);
void XTtcPs_Stop_sc(XTtcPs* xttcps);
#endif
#ifdef XPAR_XGPIOPS_NUM_INSTANCES
void XGpioPs_setup_sc(XGpioPs* xgpiops, u16 DeviceId);
#endif
#ifdef XPAR_XAXIPMON_NUM_INSTANCES
void XAxiPmon_Profile_setup_sc(XAxiPmon* xaxipmon, u16 DeviceId);
u32 XAxiPmon_Profile_get_sample_register(XAxiPmon* xaxipmon);
u32 XAxiPmon_Profile_get_sampled_metric(XAxiPmon* xaxipmon,int slot_id,
		XAxiPmon_Direction direction, XAxiPmon_Profile_Metric metric);
#endif
#ifdef XPAR_XGPIO_NUM_INSTANCES
void XGpio_setup_sc(XGpio* xgpio, u16 DeviceId);
#endif

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif
