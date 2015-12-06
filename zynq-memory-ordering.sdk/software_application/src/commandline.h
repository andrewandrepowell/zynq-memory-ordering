/*
 * commandline.h
 *
 *  Created on: Dec 3, 2015
 *      Author: scdl
 */


/*
 * Cli.h
 *
 *  Created on: Jul 3, 2015
 *      Author: Andrew Powell
 */

#ifndef COMMANDLINE_H_
#define COMMANDLINE_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "FreeRTOS.h"
#include "FreeRTOS_CLI.h"
#include "serial.h"

#include "main.h"
#include "TaskShortcuts.h"
#include "PeripheralShortcuts.h"
#include "xil_assert.h"

void Cli_write_message(char* message);
void Cli_write_message_formatted(char* message,...);
void Cli_write_assert(const char *file, int line);

#endif /* CLI_H_ */
