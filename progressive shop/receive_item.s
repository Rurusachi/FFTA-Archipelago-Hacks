.thumb

Receive_items:
    mov r0, #0x2
    lsl r0, r0, #0x8 @(start law cards at >512 (0x200))
    cmp r10, r0
    bhi Card_item_reward
    b Mission_item_reward

Mission_item_reward:
    mov r1, r10
    lsl r0, r1, #0x4
    ldr r1, =#0x0851FAA4
    add r1, r0, r1
    ldr r0, =Receive_mission_item
    mov r15, r0

@ If r10 < 0x56: image_id = 0x189
@ else: image_id = 0x18a and item_id = 
Card_item_reward:
    @ Put image_id in r4
    mov r1, r10
    push {r1, lr} @ Push id and r5
    sub r0, r1, r0 @ r0 = item_id - 200 (law card id)
    mov r10, r0
    cmp r0, #0x56
    blo Law_card
    b Antilaw_card

Law_card:
    ldr r4, =#0x189
    b FUN_080cb980


Antilaw_card:
    ldr r4, =#0x18a
    ldr r2, =#0xffab
    add r0, r0, r2
    lsl r0, r0, #0x10
    lsr r0, r0, #0x10 
    mov r10, r0 @ item_id in r10
    b FUN_080cb980


@ FUN_080cb980(pointer, image_id)
FUN_080cb980:
    mov r0, r9 @ r9 contains 0x02003cb0
    ldr r1, =#0x080cb980
    mov lr, r1
    mov r1, r4 @ image_id
    .short 0xF800 @ bl lr
    b FUN_bios_cpuSet


FUN_bios_cpuSet:
    lsl r0, r7, #0x6
    ldr r1, =#0x0600AFE0
    add r6, r0, r1
    mov r0, r9
    add r1, r6, #0x0
    mov r2, #0x40
    swi #0xb @ FUN_bios_cpuSet
    b get_name_pointer

get_name_pointer:
    ldr r0, =#0x08526680
    @ Fix to item id instead of image id
    mov r1, r10
    ldr r2, =#0x271
    add r1, r1, r2
    lsl r1, r1, #0x2
    add r1, r1, r0
    ldr r6, [r1, #0x0]
    b get_image_pointer

get_image_pointer:
    mov r0, r4 @ move image_id into r0
    ldr r1, =#0x080cb99c
    mov lr, r1
    .short 0xF800 @ bl lr
    lsl r0, r0, #0x1c
    mov r2, #0xd0
    lsl r2, r2, #0x18
    add r0, r0, r2
    lsr r0, r0, #0x10
    mov r8, r0
    b Cleanup


Cleanup:
    @ Pop and return
    pop {r0, r1}
    mov r10, r0
    mov lr, r1
    ldr r0, =Receive_items_after
    mov r15, r0
