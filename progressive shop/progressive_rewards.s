.thumb

Begin_progressive:
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

Progressive_shop_reward:
    ldr r1, =ProgressiveShopLevel
    ldrb r0, [r1]
    ldr r1, =ShopTierAmount
    ldrb r1, [r1]
    cmp r0, #0x02
    blo Shop_level_1_and_2
    cmp r0, r1
    blo Progressive_shop_increment
    b Progressive_shop_cleanup

Shop_level_1_and_2:
    push {r2}
    ldr r2, =NumberOfBattles
    ldrb r4, [r2]
    add r4, #0xA
    strb r4, [r2]
    pop {r2}
    b Progressive_shop_increment

Progressive_shop_increment:
    ldr r1, =ProgressiveShopLevel
    add r0, #0x01
    strb r0, [r1]
    b Progressive_shop_cleanup

Progressive_shop_cleanup:
    ldrh r4, =ShopUpgradeTempItem
    b Process_reward @ no item to reward

Progressive_reward:
    add r0, #0xff @(Progressive shop is 0xff)
    cmp r4, r0
    beq Progressive_shop_reward
    sub r0, #0xff
    push {r2, r3}
    sub r4, r4, r0
    ldr r1, =PathPointerStart
    lsl r0, r4, #0x2 @ Multiply by 4 (4 bytes per pointer)
    ldr r1, [r1, r0]
    ldr r0, =ProgressiveCounter
    ldrb r2, [r0, r4] @ Load counter into r2
    push {r2, r4}
    lsl r2, r2, #0x1 @ Multiply by 2 (2 bytes per item)
    ldrb r4, [r1, r2] @ Load 1st byte into r4
    add r2, #0x1
    ldrb r2, [r1, r2] @ Load 2nd byte into r0
    lsl r1, r2, #0x8
    orr r4, r1 @ Item id is now in r4
    pop {r1, r2}
    ldr r0, =PathLengthStart
    ldrb r0, [r0, r2]
    cmp r1, r0
    blo Increment_counter
    b Validate_Item @ Max counter reached


Validate_Item:
    mov r0, #0x3
    lsl r0, r0, #0x8
    cmp r4, r0
    bhs Random_item
    b Cleanup_and_return

Cleanup_and_return:
    pop {r2, r3}
    b Item_not_received

Increment_counter:
    ldr r0, =ProgressiveCounter
    add r1, #0x1
    strb r1, [r0, r2]
    b Validate_Item


Random_item:
    ldr r0, =InitializationBytePointer
    ldrb r1, [r0]
    cmp r1, #0x0
    beq Initialize_seed
    ldr r3, =xorshift
    bx r3

Initialize_seed:
    add r1, #0x1
    strb r1, [r0]
    ldr r0, =InitialSeed
    ldr r0, [r0]
    ldr r1, =CurrentState
    str r0, [r1]
    ldr r3, =xorshift
    bx r3

@ r0 modulo r1
Bios_modulo:
    swi #0x06 @ Bios div function. After: r0 = (r0 div r1), r1 = (r0 mod r1), r3 = (ABS (r0 div r1))
    add r4, r1, #1 @ Item id in r4
    b Cleanup_and_return

.arm

xorshift:
    ldr r2, =CurrentState
    ldr r3, [r2] @ State is in r2
    eor r3, r3, r3, lsl #13
    eor r3, r3, r3, lsr #17
    eor r0, r3, r3, lsl #5 @ Next state is in r0
    str r0, [r2]
    @b modulo
    ldr r1, =#0x169 @ modulo
    ldr r3, =(Bios_modulo+1)
    bx r3
