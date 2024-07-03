.thumb

@ 080cbe28 r7 = item index
Shop_loop_condition:
    ldr r0, =ShopUnlockList
    ldrb r0, [r0, r7]
    cmp r0, #0
    beq ShopLoopConditionFail
    ldr r1, =BattleNumConditionFlag
    ldrb r1, [r1]
    cmp r1, #1
    beq Battle_num_flag
Shop_tier_condition:
    ldr r1, =ProgressiveShopLevel
    ldrb r1, [r1]
    add r1, #1
    cmp r1, r0
    bge ShopLoopConditionSuccess
    b ShopLoopConditionFail

Battle_num_flag:
    ldr r1, [sp, #0xc] @ Shop tier bit flag, 0x10 = 1, 0x20 = 2, 0x40 = 3
    lsr r1, #4
    cmp r1, #4
    beq Battle_flag_fix
Battle_num_condition:
    cmp r1, r0
    bge ShopLoopConditionSuccess
    b Shop_tier_condition

Battle_flag_fix:
    sub r1, #1
    b Battle_num_condition
