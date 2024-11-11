.thumb

Process_reward:
    push {lr}
    mov r0, #0x2
    lsl r0, r0, #0x8 @(start law cards at >512 (0x200))
    cmp r4, r0
    bhi Card_item_reward

    @ Items only for show
    mov r0, r4
    bl Should_Give
    cmp r0, #0x0
    beq Write_only

    ldr r0, =#0x177
    cmp r4, r0
    bhi Mission_item_reward
    b Normal_item_reward

Normal_item_reward:
    mov r1, #0
    b Call_give_item

Mission_item_reward:
    sub r4, r4, r0
    mov r1, #1
    b Call_give_item

Card_item_reward:
    sub r4, r4, r0
    mov r1, #2
    b Call_give_item

Write_only:
    ldr r0, =#0x177
    sub r4, r4, r0
    mov r1, #1
    sub sp, #0x14
    str r1, [sp, #0x8] @ store item type for later
    b Set_coords

@ Give_item(item_id, item_type, 1?)
@ item_type: 0 = normal, 1 = mission, 2 = law card
Call_give_item:
    sub sp, #0x14
    str r1, [sp, #0x8] @ store item type for later
    ldr r0, =Give_item
    mov lr, r0
    mov r0, r4
    mov r2, #1
    .short 0xF800 @ bl lr
    b Set_coords

@ Write_item(5, 0600afe0, x_coord, y_coord, item_id, 0, item_type, 0, 0)
@ x_coord: 0x0 for left side, 0xc for right side
@ y_coord must be multiple of 2
Set_coords:
    mov r0, #4
    cmp r5, r0
    blo First_four_items
    mov r2, #0x0 @ Left side
    mov r0, #5
    cmp r5, r0
    beq Fifth_item
    b Sixth_item

First_four_items:
    mov r2, #0xc @ Right side
    mov r3, r5
    lsl r3, #1
    b Call_write_item

Fifth_item:
    mov r3, #6 @ fourth line
    b Call_write_item

Sixth_item:
    mov r3, #0 @ First line
    b Call_write_item

Call_write_item:
    mov r0, #5
    str r4, [sp, #0x0]
    mov r1, #0x0
    str r1, [sp, #0x4]
    str r1, [sp, #0xc]
    str r1, [sp, #0x10]
    ldr r1, =Write_item
    mov lr, r1
    ldr r1, =#0x0600afe0
    .short 0xF800 @ bl lr
    b Loop_cleanup

Loop_cleanup:
    add r5, #1 @ item counter
    add sp, #0x14
    pop {r1}
    mov lr, r1
    b Mission_rewards
