################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/FreeRTOS_CLI.c \
../src/PeripheralShortcuts.c \
../src/TaskShortcuts.c \
../src/UARTCommandConsole.c \
../src/amp.c \
../src/axi4_metrics_counter_dbg.c \
../src/commandline.c \
../src/freertos.c \
../src/hardware_accelerator_dbg.c \
../src/main.c \
../src/serial.c 

OBJS += \
./src/FreeRTOS_CLI.o \
./src/PeripheralShortcuts.o \
./src/TaskShortcuts.o \
./src/UARTCommandConsole.o \
./src/amp.o \
./src/axi4_metrics_counter_dbg.o \
./src/commandline.o \
./src/freertos.o \
./src/hardware_accelerator_dbg.o \
./src/main.o \
./src/serial.o 

C_DEPS += \
./src/FreeRTOS_CLI.d \
./src/PeripheralShortcuts.d \
./src/TaskShortcuts.d \
./src/UARTCommandConsole.d \
./src/amp.d \
./src/axi4_metrics_counter_dbg.d \
./src/commandline.d \
./src/freertos.d \
./src/hardware_accelerator_dbg.d \
./src/main.d \
./src/serial.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -std=c99 -mcpu=cortex-a9 -mfpu=neon -c -fmessage-length=0 -MT"$@" -I../../software_application_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


