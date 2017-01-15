# Raspino

## Introduction
Raspino is a project that aims to offer the possibility to program the Raspberry PI board like an Arduino

The Raspberry Pi is a great computer. It offers lots of possibilities for embedded applications. Linux is a great operating system that has proven its capabilities for many applications. But for some embedded applications Linux is much too powerful. When I program an embedded system, it is sometimes critical to control exactly what is happening at what time e.g. to create a signal with no jitter. This is not really feasible with Linux because there are so many concurrent processes that have to share the CPU cycles. There are alternative like using Real time Linux variant but this remains very complex. 
What I want to do is to have access to the Raspberry PI power (32 bits ARM, HDMI output…) while programming it like an Arduino (i.e. run a single program that has access to the full system

## Bare metal Assembly programming
The solution that we will explore today is to write a program in assembly language and to run it on the Raspberry PI without any operating system!

## Step 01 programmin the GPIOs

### Address issues
To access GPIO in assembly you need to know the correct addresses. 

On Raspberry PI with 512Mbytes (i.e. The Raspberry PI 1 and Zero) the GPIO base Address is 0x2000 0000

On Raspberry PI with 1024Mbytes (i.e. The Raspberry PI 2 and 3) the GPIO base Address is 0x3F00 0000 

(note that in the BCM2835 documentation, this address space is mapped to 0x7E00 0000. This is not important for us except when we read the BCM2835 datasheet).

### Emulating some Digital IO Arduino functions

We  will try to emulate the Arduino functions that manipulate the GPIOs
So we will write the following functions:
    void pinMode(u32 pinMode_pin, u32 pinMode_mode)
and
	void digitalWrite(u32 digitalWrite_pin,u32 digitalWrite_value)

They behave in a similar as the Arduino functions.
This means that the classic Arduino blink

    int ledPin = 13
    void setup()
    {
      pinMode(ledPin, OUTPUT);
    }
    
    void loop()
    {
      digitalWrite(ledPin, HIGH);  
      delay(1000); 
      digitalWrite(ledPin, LOW); 
      delay(1000); 
    }

can be written


    /* for Raspberry PI 2, or 3 */
    .equ ACTIVE_LED_PIN, 47  
    
    /*for Raspberry PI 1, or ZERO */
    /*.equ ACTIVE_LED_PIN, 16  */
    .include "digital_io.h"
    
    .section .init
    .globl _start
    _start:
        b setup
    
    
    .section .text
    setup:
        /* initialize the stack */
        mov sp,#0x8000

        /* pinMode(ACTIVE_LED_PIN,OUTPUT) */
        mov pinMode_pin,#ACTIVE_LED_PIN
        mov pinMode_mode,#OUTPUT
        bl pinMode

    loop$:
        
        /* digitalWrite(ACTIVE_LED_PIN,1) */
        mov digitalWrite_pin,#ACTIVE_LED_PIN
        mov digitalWrite_value,#1
        bl digitalWrite
    
        /* delay(1000) */
        ldr delay_ms,=1000
        bl delay
    
        /* digitalWrite(ACTIVE_LED_PIN,0) */
        mov digitalWrite_pin,#ACTIVE_LED_PIN
        mov digitalWrite_value,#0
        bl digitalWrite
    
        /* delay(1000) */
        ldr delay_ms,=1000
        bl delay
    
        b loop$

## Deploying this code
To deploy the code
1.	Compile it with make
2.	On an existing Raspberry PI micro SD replace the file “kernel.img” by the “kernel.img” you just compiled (it is recommended to rename the old “kernel.img” instead of overwriting it
3.	Insert the micro SD card in the Raspberry PI and power it on



## Other resources
External documentation
	University of Cambridge excellent OS on Raspberry PI assembly course (highly recommended but must be adapted for newer Raspberry Pi)  http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/index.html
The information about adaptation to Raspberry PI 2 is available in https://www.raspberrypi.org/forums/viewtopic.php?f=72&t=105735

Example of a kernel developed for Raspberry Pi https://rpidev.wordpress.com/ using assembly and C/C++

How to configure the environment: http://hertaville.com/development-environment-raspberry-pi-cross-compiler.html

Documentation of the Raspberry PI IO chip it (chip BCM2836) contains address of IO registers  mailboxes and interrupts https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2836/QA7_rev3.4.pdf
But the full datasheet of the BCM2836 is in 
https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2835/BCM2835-ARM-Peripherals.pdf
