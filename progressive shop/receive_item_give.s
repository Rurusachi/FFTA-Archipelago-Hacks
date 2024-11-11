.thumb

Receive_item_give:
    push {lr}
    ldr r0, =#0x0201F46C
    lsl r1, r4, #0x1
    add r1, r1, r0
    ldrh r0, [r1, #0x0] @ Item_id in r0

    @ Skip giving certain items
    bl Should_Give
    cmp r0, #0x0
    beq Cleanup

    mov r1, #0x2
    lsl r1, r1, #0x8 @(start law cards at >512 (0x200))
    cmp r0, r1
    bhi Card_item_reward
    ldr r1, =#0x177
    cmp r0, r1
    bhi Mission_item_reward
    b Normal_item_reward

Normal_item_reward:
    mov r1, #0x0
    b Call_give_item


Mission_item_reward:
    sub r0, r0, r1
    mov r1, #0x1
    b Call_give_item


Card_item_reward:
    sub r0, r0, r1
    mov r1, #0x2
    b Call_give_item

Call_give_item:
    mov r2, #0x1
    ldr r3, =Give_item
    mov lr, r3
    .short 0xF800 @ bl lr

Cleanup:
    pop {r3}
    mov lr, r3
    ldr r3, =Receive_items_give_after
    mov r15, r3
