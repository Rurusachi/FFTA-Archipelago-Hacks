.thumb

Receive_item_write:
    push {lr}
After_progressive:
    @ Progressive items
    mov r0, #0x3
    lsl r0, r0, #0x8 @(start progressive items at >=768 (0x300))
    cmp r10, r0
    bhs Progressive_reward

    mov r0, #0x2
    lsl r0, r0, #0x8 @(start law cards at >512 (0x200))
    cmp r10, r0
    bhi Card_item_reward
    
    pop {r1}
    mov lr, r1
    ldr r0, =#0x177
    cmp r10, r0
    bhi Mission_item_reward
    b Normal_item_reward

Progressive_reward:
    mov r0, r10
    bl Progressive_Item
    mov r10, r0
    @ Write to memory address
    ldr r1, =Receive_item_offset
    ldr r1, [r1, #0x0]
    lsl r1, r1, #0x1
    ldr r2, =Receive_item_address
    add r1, r2, r1
    strh r0, [r1, #0x0]

    b After_progressive

Normal_item_reward:
    ldr r1, =#0x0851D180
    mov r2, r10
    ldr r0, =Receive_write_normal_item
    mov r15, r0

Mission_item_reward:
    ldr r0, =Receive_write_mission_item
    mov r15, r0

@ If r10 < 0x56: image_id = 0x189
@ else: image_id = 0x18a and item_id = 
Card_item_reward:
    @ Put image_id in r1
    mov r1, r10
    push {r1} @ Push id
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
    b cleanup


cleanup:
    @ Pop and return
    pop {r0}
    pop {r1}
    mov r10, r0
    mov lr, r1
    ldr r0, =Receive_item_write_after
    mov r15, r0
