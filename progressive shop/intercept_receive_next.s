.thumb

intercept_receive_next:
    ldr r1, =Receive_item_offset
    ldr r1, [r1, #0x0]
    add r1, #0x1
    lsl r1, r1, #0x1
    ldr r2, =Receive_item_address
    add r1, r2, r1
    ldrh r0, [r1, #0x0]
    cmp r0, #0x0
    beq Receive_item_next_end
    b Receive_item_next_continue