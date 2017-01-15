/* for Raspberry PI 2, or 3 */
.equ ACTIVE_LED_PIN, 47  
/*for Raspberry PI 1, or ZERO */
/*.equ ACTIVE_LED_PIN, 16*/

.include "digital_io.h"


setup:
    setupStart
    
    /* pinMode(ACTIVE_LED_PIN,OUTPUT) */
    mov pinMode_pin,#ACTIVE_LED_PIN
    mov pinMode_mode,#OUTPUT
    bl pinMode
    
    setupEnd

loop:
    loopStart
    
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
    
    /* delay(100) */
    ldr delay_ms,=100
    bl delay

    loopEnd
    
