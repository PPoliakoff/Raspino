/* digital_io /
/* P. Poliakoff 2017 */
/* this library tries to emulate the Raspberry PI digital IOs functions on a bare metal Raspberry pi */

.include "digital_io.h"

/*
void pinMode(u32 pinMode_pin, u32 pinMode_mode)

pinMode_pin: [0..53]
pinMode_mode: [0..7]

STILL TO DO WRITE SUPPORT FOR MODE INPUT_PULLUP

*/
.globl pinMode
pinMode:


    registerAddress .req r2
    mask .req r3
    tmp .req r4

    push {r4,lr}
    cmp pinMode_pin,#53
    pophi {r4,pc}

    and pinMode_mode,pinMode_mode,#7

    ldr registerAddress, =GPIO_BASE_ADDRESS

loop:
    cmp pinMode_pin,#9
    ble loopend 
    sub pinMode_pin,#10
    add registerAddress,#4
    b loop
loopend:
    @ pinMode_pin is the remainder of pin_mode_pin/10
    add  pinMode_pin, pinMode_pin, lsl #1 @ multiply pinMode_pin by 3 to get the offset

    mov mask,#7
    lsl mask,pinMode_pin
    mvns mask,mask
 
    ldr tmp,[registerAddress]
    and tmp,mask
    orr tmp, pinMode_mode,lsl pinMode_pin
    str tmp,[registerAddress]

    .unreq tmp
    .unreq mask
    .unreq registerAddress
     
    pop {r4,pc}

/*
void digitalWrite(u32 digitalWrite_pin,u32 digitalWrite_value)
*/
.globl digitalWrite
digitalWrite:
    registerAddress .req r2
    mask .req r3

    push {lr}
    cmp digitalWrite_pin,#53
    bhi exit
    ldr registerAddress,=GPIO_BASE_ADDRESS
    teq digitalWrite_value, #0
    addeq registerAddress,#0x1C
    addne registerAddress,#0x28

    cmp digitalWrite_pin,#31
    addhi registerAddress,#4
    and digitalWrite_pin,#31

    mov mask,#1
    lsl mask,digitalWrite_pin
    str mask,[registerAddress]

    .unreq mask
    .unreq registerAddress

exit:
    pop {pc}

/*========================================================
void delay(u32 delay_ms)
==========================================================*/
/* delay should be in Time module !! */

.globl delay
delay:
    push {lr}

    /* multiply delay by 1024 should be 1000 */
    lsl  delay_ms,delay_ms,#10


     @ delay should be implemented via a query on timer registers
delayloop$:
    subs delay_ms,#1
    bne delayloop$

    pop {pc}
