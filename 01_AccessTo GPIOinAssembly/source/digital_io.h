
/* parameters names */
digitalWrite_pin .req r0
digitalWrite_value .req r1

pinMode_pin .req r0
pinMode_mode .req r1

delay_ms .req r0 /* delay should be in Time module !! */


/* define */
.equ OUTPUT, 1
.equ INPUT, 0
.equ INPUT_PULLUP, 8

/* for Raspberry PI 2, or 3 */

.equ GPIO_BASE_ADDRESS, 0x3F200000 

/*for Raspberry PI 1, or ZERO */
/*
.equ GPIO_BASE_ADDRESS,0x20200000  
*/


.macro loopStart
    .globl loop 
    push {lr}
.endm

.macro loopEnd
    pop {pc}
.endm

.macro setupStart
    .globl setup
    push {lr}
.endm

.macro setupEnd
    pop {pc}
.endm
