.thumb

@ 080cbe28 r7 = item index
Shop_loop_condition:
    ldr r0, =ShopUnlockList
    ldrb r0, [r0, r7]
    cmp r0, #0
    beq ShopLoopConditionFail
    push {r2} @ Unsure if r2 is used later, saving just in case. Offsets shop tier flag from 0x0c to 0x10
    ldr r1, =BattleNumConditionFlag
    ldrb r1, [r1]
    cmp r1, #1
    bge Battle_num_flag
Shop_tier_level_only:
    mov r2, #1
Shop_tier_level:
    ldr r1, =ProgressiveShopLevel
    ldrb r1, [r1]
    add r1, r2
    cmp r1, r0
Shop_tier_end:
    pop {r2} @ Should not affect flags
    bge ShopLoopConditionSuccess
    b ShopLoopConditionFail

Battle_num_flag:
    ldr r2, [sp, #0x10] @ Shop tier bit flag, 0x10 = 1, 0x20 = 2, 0x40 = 3
    lsr r2, #4
    cmp r2, #4
    beq Battle_flag_fix
Battle_num_condition:
    cmp r1, #2
    bge Shop_tier_level @ Stacking with upgrades
    mov r1, r2
    cmp r1, r0
    bge Shop_tier_end
    b Shop_tier_level_only

Battle_flag_fix:
    sub r2, #1
    b Battle_num_condition
