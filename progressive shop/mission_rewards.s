.thumb

Mission_rewards:
    @ item_1 
    ldrb r1, [r7, #0x08]
    ldrb r0, [r7, #0x09]
    lsl r4, r0, #0x1e
    lsr r4, r4, #0x16
    orr r4, r1
    mov r1, #0x0
    strb r1, [r7, #0x08]
    lsr r1, r0, #0x2
    lsl r1, r1, #0x2
    strb r1, [r7, #0x09]
    cmp r4, #0x0
    bne Item_not_received

item_2:
    ldrb r1, [r7, #0x09]
    ldrb r0, [r7, #0x0a]
    lsr r1, r1, #0x2
    lsl r4, r0, #0x1c
    lsr r4, r4, #0x16
    orr r4, r1
    mov r1, #0x0
    strb r1, [r7, #0x09]
    lsr r1, r0, #0x4
    lsl r1, r1, #0x4
    strb r1, [r7, #0x0a]
    cmp r4, #0x0
    bne Item_not_received

Item_3:
    ldrb r1, [r7, #0x0a]
    ldrb r0, [r7, #0x0b]
    lsr r1, r1, #0x4
    lsl r4, r0, #0x1a
    lsr r4, r4, #0x16
    orr r4, r1
    mov r1, #0x0
    strb r1, [r7, #0x0a]
    strb r1, [r7, #0x0b]
    cmp r4, #0x0
    bne Item_not_received

Item_4:
    ldrb r1, [r7, #0x0c]
    ldrb r0, [r7, #0x0d]
    lsl r4, r0, #0x1e
    lsr r4, r4, #0x16
    orr r4, r1
    mov r1, #0x0
    strb r1, [r7, #0x0c]
    lsr r1, r0, #0x2
    lsl r1, r1, #0x2
    strb r1, [r7, #0x0d]
    cmp r4, #0x0
    bne Item_not_received

Item_5:
    ldrb r1, [r7, #0x0d]
    ldrb r0, [r7, #0x0e]
    lsr r1, r1, #0x2
    lsl r4, r0, #0x1c
    lsr r4, r4, #0x16
    orr r4, r1
    mov r1, #0x0
    strb r1, [r7, #0x0d]
    lsr r1, r0, #0x4
    lsl r1, r1, #0x4
    strb r1, [r7, #0x0e]
    cmp r4, #0x0
    bne Item_not_received

Item_6:
    ldrb r1, [r7, #0x0e]
    ldrb r0, [r7, #0x0f]
    lsr r1, r1, #0x4
    lsl r4, r0, #0x1a
    lsr r4, r4, #0x16
    orr r4, r1
    mov r1, #0x0
    strb r1, [r7, #0x0e]
    strb r1, [r7, #0x0f]
    cmp r4, #0x0
    bne Item_not_received

Items_received:
    ldr r0, =EndRoutine
    mov r15, r0

Item_not_received:
    mov r0, #0x3
    lsl r0, r0, #0x8 @(start progressive items at >=768 (0x300))
    cmp r4, r0
    bhs Progressive_reward
    b Process_reward

Progressive_reward:
    mov r0, r4
    bl Progressive_Item
    mov r4, r0
    b Item_not_received
