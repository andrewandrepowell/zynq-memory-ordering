#ifndef TASK_SHORTCUTS_H_
#define TASK_SHORTCUTS_H_

#include <xscugic.h>

#include <FreeRTOS.h>
#include <task.h>
#include <queue.h>

#define TASK_XLARG_STACK_SIZE	(configMINIMAL_STACK_SIZE+1024)
#define TASK_LARGE_STACK_SIZE 	(configMINIMAL_STACK_SIZE+512)
#define TASK_MEDIU_STACK_SIZE	(configMINIMAL_STACK_SIZE+256)

#define TASK_POOL_SIZE 			16

typedef void (*TaskFuncHandle_t)(void*);
typedef void (*TaskCreateFuncHandle_t)(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name);

void vSetupFreeRTOS_sc();
void xTaskCreate_sc(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name);
void xTaskCreateMedium_sc(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name);
void xTaskCreateRealTime_sc(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name);
void xTaskCreateXLarge_sc(TaskHandle_t* task, TaskFuncHandle_t func, void* param, const char* name);

#endif
