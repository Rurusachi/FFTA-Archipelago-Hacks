.thumb

@ r6 = index, r2 = pointer to first item list
Shop_init:
    push {r2, r6}
    mov r6, #0x03
    ldr r2, =ShopUnlockListStart
    b Add_shop_unlocks

Add_shop_unlocks:
    @ldr r2, =ShopTierAmount
    @ldrb r0, [r2]
    ldr r1, =ProgressiveShopLevel
    ldrb r1, [r1]
    cmp r6, r1 @ r6 = index, r1 = shop level
    bhi Shop_cleanup
    b Unlock_item

@ pointer in r2, index in r6
Unlock_item:
    ldrb r0, [r2]
    ldrb r1, [r2, #0x01]
    lsl r7, r1, #0x08
    orr r7, r0
    cmp r7, #0x0
    bne Add_to_shop
    add	r6, #1
    add r2, #0x04 @ 2 byte buffer between lists
    b Add_shop_unlocks

@ This is a modified section from the part of Leonarth's code we're hooking into (https://github.com/LeonarthCG/FFTA_Engine_Hacks/blob/master/Engine%20Hacks/newInventory/ASM/shopBuyList.s)
@ Mainly just the jumps are changed
Add_to_shop:
    @get the tab it belongs to
    ldr	r0, =#0x80CBE7C
    ldr	r0, [r0]
    lsl	r1, r7, #5
    add	r1, r0
    ldrb r1, [r1, #0x08]
    ldr	r0, =newItemTabs
    ldrb r0, [r0, r1]
    cmp	r0, r9
    bne	Increment_and_loop

    @get the offset of this items data
    ldr	r4, [sp, #0x08]
    lsl	r1, r5, #2
    add	r4, r1

    @and store the data
    strh r7, [r4, #0x00] @item id
    ldr	r0, =#0x2001940
    ldrb r0, [r0, r7]
    strb r0, [r4, #0x02] @owned ammount
    mov	r0, r7
    ldr	r3, =checkEquippedamount
    mov	lr, r3
    .short 0xF800 @ bl lr
    strb r0, [r4, #0x03] @equipped ammount
    add	r5, #1

Increment_and_loop:
    add r2, #0x2
    b Unlock_item

@ Our hook is overriding the end section of Leonarth's code, so placing it here instead
Shop_cleanup:
    pop {r2, r6}
    mov	r0, r5
    add	sp, #0x14
    pop	{r3-r5}
    mov	r8, r3
    mov	r9, r4
    mov	r10, r5
    pop	{r4-r7}
    pop	{r1}
    bx	r1
