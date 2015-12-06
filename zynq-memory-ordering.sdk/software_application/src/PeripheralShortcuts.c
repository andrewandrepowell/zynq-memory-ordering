/**
* @file PeripheralShortcuts.c
*
* Contains the definitions and the documentation of the functions that
* simplify the usage of some of the Standalone operating system's more
* advance functions.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- ---------------------------------------------------
*       aap 06/29/15 Initial version
* </pre>
*
* @note
*
* aap - Andrew Andre Powell of Temple University's College of Engineering
*
******************************************************************************/
/****************** Include Files (User Defined)  ********************/
#include "PeripheralShortcuts.h"

/**************** Global Definitions (User Defined)*******************/
#ifdef XPAR_XSCUGIC_NUM_INSTANCES

/**
 * Local reference to the driver for the interrupt controller.
 */
static XScuGic* xscugic = NULL;

#endif

/*************** Function Prototypes (User Defined) ******************/
/*****************************************************************************
*
* Configure an Io structure to extend the functionality of a parent object
* intended to send and/or receive characters.
*
* @param	io						The io structure.
* @param	parent					The parent object whose functionality is extended.
* @param	writeHandle				A function whose inputs are the parent object,
* 									buffer, and size of buffer in bytes. Should perform
* 									a write operation and return the number of characters
* 									actually transmitted.
* @param	readHandle				A function whose inputs are the parent object,
* 									buffer, and size of buffer in bytes. Should perform
* 									a read operation and return the number of characters
* 									actually received.
* @param	addressHandle			Location associated with the parent object. Its meaning
* 									is up to the programmer's discretion.
*
* @return	None.
*
* @note		Any of the handles can be NULL, but will cause assertions to fail if an
* 			io method dependent on the NULLed handle is called.
*
******************************************************************************/
void Io_setup(Io* io, void* parent,
		Io_Handle writeHandle, Io_Handle readHandle,
		Io_Address_Handle addressHandle) {

	Xil_AssertVoid(io != NULL);
	memset(io, 0, sizeof(Io));
	io->parent = parent;
	io->writeHandle = writeHandle;
	io->readHandle = readHandle;
	io->addressHandle = addressHandle;
}

/*****************************************************************************
*
* Perform a write operation from a buffer of data.
*
* @param	io						The io structure.
* @param	buffer					From where the data is written.
* @param	size					The size of the data in bytes.
*
* @return	The number of bytes actually written.
*
* @note		None.
*
******************************************************************************/
size_t Io_write(Io* io, void* buffer, size_t size) {
	Xil_AssertNonvoid(io != NULL);
	Xil_AssertNonvoid(io->writeHandle != NULL);
	return io->writeHandle(io->parent, buffer, size);
}

void Io_writeChar(Io* io, char character) {
	Io_write(io, (void*)&character, 1);
}

void Io_writeChars(Io* io, char character, size_t numberOfChars) {
	size_t i;
	for (i = 0; i < numberOfChars; i++)
		Io_writeChar(io, character);
}

void Io_writeString(Io* io, char* nullTerminatedString) {
	Xil_AssertVoid(nullTerminatedString != NULL);
	Io_write(io, (void*)nullTerminatedString, strlen(nullTerminatedString)+1);
}

void Io_writeFormattedString(Io* io, char* nullTerminatedString, ...) {
	va_list args;
	va_start(args, nullTerminatedString);
	Io_writeFormattedStringVariadic(io,nullTerminatedString,&args);
	va_end(args);
}

void Io_writeFormattedStringVariadic(Io* io, char* nullTerminatedString,va_list* args) {
	const size_t BUFFER_SIZE = 512;
	char buffer[BUFFER_SIZE];
	vsprintf(buffer, nullTerminatedString, *args);
	Io_writeString(io, buffer);
}

size_t Io_read(Io* io, void* buffer, size_t size) {
	Xil_AssertNonvoid(io != NULL);
	Xil_AssertNonvoid(io->readHandle != NULL);
	return io->readHandle(io->parent, buffer, size);
}

size_t Io_readChar(Io* io, char* character) {
	return Io_read(io, (void*)character, 1);
}

void Io_setAddress(Io* io, void* address) {
	Xil_AssertVoid(io->addressHandle != NULL);
	io->addressHandle(io->parent, address);
}

size_t Io_writeToAddress(Io* io, void* address, void* buffer, size_t size) {
	Io_setAddress(io, address);
	return Io_write(io, buffer , size);
}

size_t Io_readFromAddress(Io* io, void* address, void* buffer, size_t size) {
	Io_setAddress(io, address);
	return Io_read(io, buffer , size);
}

#ifdef XPAR_XUARTPS_NUM_INSTANCES

static size_t XUartPs_writeForIo(void* parent, void* buffer, size_t size) {
	XUartPs* xuartps = (XUartPs*)parent;
	size_t totalWritten = 0;

	// block until data is written
	while (totalWritten < size)
		totalWritten += XUartPs_Send(xuartps, (u8*)(buffer+totalWritten), size);
	while (XUartPs_IsSending(xuartps));

	return size;
}

static size_t XUartPs_readForIo(void* parent, void* buffer, size_t size) {
	return  XUartPs_Recv((XUartPs*)parent, (u8*)buffer, size);
}

void XUartPs_setup_sc(XUartPs* xuartps, Io* io, u16 DeviceId, u32 BaudRate) {

	XUartPs_Config* config;
	int result;

	Io_setup(io, (void*)xuartps,
		XUartPs_writeForIo, XUartPs_readForIo,
		NULL);

	config = XUartPs_LookupConfig(DeviceId);
	Xil_AssertVoid(config != NULL);
	result = XUartPs_CfgInitialize(xuartps, config, config->BaseAddress);
	Xil_AssertVoid(result == XST_SUCCESS);
	result = XUartPs_SetBaudRate(xuartps, BaudRate);
	Xil_AssertVoid(result == XST_SUCCESS);
	XUartPs_SetOperMode(xuartps, XUARTPS_OPER_MODE_NORMAL);
	result = XUartPs_SelfTest(xuartps);
	Xil_AssertVoid(result == XST_SUCCESS);
}

#endif

#ifdef XPAR_XSCUGIC_NUM_INSTANCES

void XScuGic_setup_sc(XScuGic* xscugic, u16 DeviceId) {
	int Status;
	XScuGic_Config *GicConfig;
	GicConfig = XScuGic_LookupConfig(DeviceId);
	Xil_AssertVoid(GicConfig!=NULL);

	Status = XScuGic_CfgInitialize(xscugic,GicConfig,GicConfig->CpuBaseAddress);
	Xil_AssertVoid(Status==XST_SUCCESS);

	Status = XScuGic_SelfTest(xscugic);
	Xil_AssertVoid(Status==XST_SUCCESS);

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) XScuGic_InterruptHandler,
			xscugic);
	Xil_ExceptionEnable();
}

void XScuGic_setXScuGic_sc(XScuGic* xsc) {
	xscugic = xsc;
}

void XScuGic_Connect_sc(u32 Int_Id, Xil_InterruptHandler Handler, void *CallBackRef) {
	Xil_AssertVoid(XScuGic_Connect(xscugic, Int_Id, Handler, CallBackRef) == XST_SUCCESS);
}

void XScuGic_Enable_sc(u32 Int_Id) {
	XScuGic_Enable(xscugic, Int_Id);
}

void XScuGic_Disable_sc(u32 Int_Id) {
	XScuGic_Disable(xscugic, Int_Id);
}

void XScuGic_SetPriorityTriggerType_sc(u32 Int_Id, u8 Priority, u8 Trigger) {
	XScuGic_SetPriorityTriggerType(xscugic,Int_Id,Priority,Trigger);
}

void XScuGic_GetPriorityTriggerType_sc(u32 Int_Id, u8 *Priority, u8 *Trigger) {
	XScuGic_GetPriorityTriggerType(xscugic,Int_Id,Priority,Trigger);
}

// It is extremely important to note the id for the first cpu (i.e. cpu 0) is actually
// 1, whereas the id for the second cpu (i.e. cpu 1) is actually 2.
void XScuGic_SoftwareIntr_sc(u32 Int_Id, u32 Cpu_Id) {
	int Status;
	Status =  XScuGic_SoftwareIntr(xscugic,Int_Id,Cpu_Id);
	Xil_AssertVoid(Status==XST_SUCCESS);
}

#endif

#ifdef XPAR_XTTCPS_NUM_INSTANCES

void XTtcPs_setup_sc(XTtcPs* xttcps, u16 DeviceId) {
	XTtcPs_Config* Config;
	Config = XTtcPs_LookupConfig(DeviceId);
	Xil_AssertVoid(Config != NULL);
	Xil_AssertVoid(XTtcPs_CfgInitialize(xttcps, Config, Config->BaseAddress) == XST_SUCCESS);
}

void XTtcPs_Stop_sc(XTtcPs* xttcps) {
	XTtcPs_Stop(xttcps);
	XTtcPs_ResetCounterValue(xttcps);
}

#endif

#ifdef XPAR_XGPIOPS_NUM_INSTANCES

void XGpioPs_setup_sc(XGpioPs* xgpiops, u16 DeviceId) {
	XGpioPs_Config* Config;
	int Result;
	Config = XGpioPs_LookupConfig(DeviceId);
	Xil_AssertVoid(Config != NULL);
	Result = XGpioPs_CfgInitialize(xgpiops, Config, Config->BaseAddr);
	Xil_AssertVoid(Result == XST_SUCCESS);
}

#endif

#ifdef XPAR_XAXIPMON_NUM_INSTANCES

void XAxiPmon_Profile_setup_sc(XAxiPmon* xaxipmon, u16 DeviceId) {
	u32 BaseAddress;
	u32 register_value;
	XAxiPmon_Config* ConfigPtr;
	ConfigPtr = XAxiPmon_LookupConfig(DeviceId);
	Xil_AssertVoid(ConfigPtr!=NULL);
	BaseAddress = ConfigPtr->BaseAddress;
	XAxiPmon_CfgInitialize(xaxipmon,ConfigPtr,BaseAddress);
	XAxiPmon_WriteReg(BaseAddress,XAPM_SI_HIGH_OFFSET,2);
	XAxiPmon_WriteReg(BaseAddress,XAPM_SI_LOW_OFFSET,45645);
	//register_value = XAxiPmon_ReadReg(BaseAddress,XAPM_SICR_OFFSET);
	XAxiPmon_WriteReg(BaseAddress,XAPM_SICR_OFFSET,XAPM_SICR_LOAD_MASK);
	XAxiPmon_WriteReg(BaseAddress,XAPM_SICR_OFFSET,XAPM_SICR_ENABLE_MASK);
	XAxiPmon_WriteReg(BaseAddress,XAPM_SICR_OFFSET,XAPM_SICR_MCNTR_RST_MASK);
	//register_value = XAxiPmon_ReadReg(BaseAddress,XAPM_CTL_OFFSET);
	XAxiPmon_WriteReg(BaseAddress,XAPM_CTL_OFFSET,XAPM_CR_MCNTR_RESET_MASK);
	XAxiPmon_WriteReg(BaseAddress,XAPM_CTL_OFFSET,XAPM_CR_MCNTR_ENABLE_MASK);
}

u32 XAxiPmon_Profile_get_sample_register(XAxiPmon* xaxipmon) {
	u32 BaseAddress = xaxipmon->Config.BaseAddress;
	return XAxiPmon_ReadReg(BaseAddress,XAPM_SR_OFFSET);
}

u32 XAxiPmon_Profile_get_sampled_metric(XAxiPmon* xaxipmon,int slot_id,
		XAxiPmon_Direction direction, XAxiPmon_Profile_Metric metric) {
	u32 BaseAddress = xaxipmon->Config.BaseAddress;
	u32 register_offset = XAPM_SMC0_OFFSET;
	register_offset += ((u32)slot_id*0x60);
	register_offset += ((u32)direction*0x30);
	register_offset += ((u32)metric*0x10);
	return XAxiPmon_ReadReg(BaseAddress,register_offset);
}

#endif

#ifdef XPAR_XGPIO_NUM_INSTANCES

void XGpio_setup_sc(XGpio* xgpio, u16 DeviceId) {
	int Status;
	Status = XGpio_Initialize(xgpio,DeviceId);
	Xil_AssertVoid(Status==XST_SUCCESS);
}

#endif
