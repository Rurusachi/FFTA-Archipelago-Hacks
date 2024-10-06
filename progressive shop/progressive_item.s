.thumb

@ Progressive_reward(item_id)
@ Returns item_id
@ Sets flags in memory
Progressive_item:
    push {r4}
    mov r4, r0
    mov r0, #0x3
    lsl r0, r0, #0x8 @(start progressive items at >=768 (0x300))
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

Return:
    mov r0, r4
    pop {r4}
    bx lr

Progressive_shop_reward:
    ldr r4, =ProgressiveShopLevel
    ldrb r0, [r4]
    ldr r1, =ShopTierAmount
    ldrb r1, [r1]
    cmp r0, r1
    blo Progressive_shop_increment
    b Progressive_shop_cleanup

Progressive_shop_increment:
    add r0, #0x01
    strb r0, [r4]
    b Progressive_shop_cleanup

Progressive_shop_cleanup:
    ldrh r4, =ShopUpgradeTempItem
    b Return @ no item to reward

Validate_Item:
    mov r0, #0x3
    lsl r0, r0, #0x8
    cmp r4, r0
    bhs Random_item
    b Cleanup

Cleanup:
    pop {r2, r3}
    b Return

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
    cmp r1, #0x0
    bge Bios_modulo_end
    neg r1, r1
Bios_modulo_end:
    add r4, r1, #1 @ Item id in r4
    b Cleanup




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
