/* for Raspberry PI 2, or 3 */
.equ ACTIVE_LED_PIN, 47  

/*for Raspberry PI 1, or ZERO */
/*
.equ ACTIVE_LED_PIN, 16  
*/


.include "digital_io.h"

.section .init
.globl _start
_start:
    b main

.section .text

/* this is the main program. It calls "setup" once and loop repeatitively */
main:
    /* initialize the stack */
    mov sp,#0x8000
    bl setup
loop$:
    bl loop
    b loop$
