.thumb

@ shouldGive(item_id)
@ returns 0 or original item_id
shouldGive:
    ldr r3, =Items_for_display_only
loop:
    ldrb r1, [r3, #0x00]
    add r3, r3, #0x01
    ldrb r2, [r3, #0x00]
    add r3, r3, #0x01
    lsl r2, r2, #0x8
    orr r1, r2
    cmp r1, #0x00
    beq no_match
    cmp r0, r1
    beq match
    b loop

match:
    mov r0, #0x0
no_match:
    bx lr
