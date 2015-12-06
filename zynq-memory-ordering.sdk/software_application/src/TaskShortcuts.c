#include "TaskShortcuts.h"

#define XLARG_STACK_SIZE	TASK_XLARG_STACK_SIZE
#define LARGE_STACK_SIZE 	TASK_LARGE_STACK_SIZE
#define MEDIU_STACK_SIZE	TASK_MEDIU_STACK_SIZE

extern void vPortInstallFreeRTOSVectorTable( void );
static void xTaskCreate_sc_base(
		TaskHandle_t* task,
		TaskFuncHandle_t func,
		void* param, const char* name,
		size_t stacksize, size_t priority);

extern XScuGic xInterruptController;

void xTaskCreate_sc_base(
		TaskHandle_t* task,
		TaskFuncHandle_t func,
		void* param, const char* name,
		size_t stacksize, size_t priority) {
	xTaskCreate(
		func,					/* The function called when the thread is executed */
		name, 					/* name given to the thread for debugging purposes */
		stacksize, 				/* stack size for calling functions from thread */
		param,					/* pointer to the thread for access to handler */
		priority,				/* priority is set to the default */
		task);					/* return handle for the thread */
	configASSERT(task != NULL);
}

void xTaskCreate_sc(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name) {
	xTaskCreate_sc_base(task, func, param, name, LARGE_STACK_SIZE, tskIDLE_PRIORITY);
}

void xTaskCreateMedium_sc(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name) {
	xTaskCreate_sc_base(task, func, param, name, MEDIU_STACK_SIZE, tskIDLE_PRIORITY);
}

void xTaskCreateRealTime_sc(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name) {
	xTaskCreate_sc_base(task, func, param, name, LARGE_STACK_SIZE, configTIMER_TASK_PRIORITY);
}

void xTaskCreateXLarge_sc(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name) {
	xTaskCreate_sc_base(task, func, param, name, XLARG_STACK_SIZE, tskIDLE_PRIORITY);
}

