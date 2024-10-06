.macro SET_FUNC name, value
	.global \name
	.type   \name, %function
	.set    \name, \value
.endm

@ Functions

SET_FUNC Mission_rewards, (0x08b30400+1)
SET_FUNC Process_reward, (0x08b30800+1)
SET_FUNC Should_Give, (0x08b30C00+1)
SET_FUNC Receive_item_write, (0x08b30D00+1) @ Intercept point: 0x08039f68(start of mission item handling)
SET_FUNC Receive_item_give, (0x08b30E00+1) @ Intercept point: 0x0803a5f0
@SET_FUNC Receive_item_next, (0x08b30E60+1)
SET_FUNC Progressive_Item, (0x08b30F00+1)

SET_FUNC EndRoutine, (0x080461c0+1)


SET_FUNC Give_item, (0x08038858+1)
SET_FUNC Write_item, (0x08037a30+1)

@ Progressive rewards

.global ProgressiveCounter
.set    ProgressiveCounter, 0x02002AF2 @ Seems to be unused memory space, we use 4 bytes (0x02002AF2 - 0x02002AF5)

.global InitializationBytePointer
.set    InitializationBytePointer, 0x02002AF6

.global CurrentState
.set    CurrentState, 0x02002AF8

.global InitialSeed
.set    InitialSeed, 0x08b30604

.global PathPointerStart
.set    PathPointerStart, 0x08b30608

.global PathLengthStart
.set    PathLengthStart, (PathPointerStart + 16)

@ Data layout (Set by archipelago patcher)
@ 08XXXXXX (Path 1 items pointer) 	(PathPointerStart)
@ 08YYYYYY (Path 2 items pointer) 	(PathPointerStart+4)
@ 08ZZZZZZ (Path 3 items pointer) 	(PathPointerStart+8)
@ 08WWWWWW (path 4 items pointer) 	(PathPointerStart+12)
@ XXYYZZWW (Path lengths) 			(PathLengthStart)

@ Progressive shop

.global Shop_loop_condition
.set Shop_loop_condition, 0x080cbea4

.global Shop_end
.set Shop_end, 0x080cbf20

.global ShopLoopConditionSuccess
.set ShopLoopConditionSuccess, 0x080cbe38

.global ShopLoopConditionFail
.set ShopLoopConditionFail, 0x080cbe92

.global ProgressiveShopLevel
.set    ProgressiveShopLevel, 0x02002AF7

.global NumberOfBattles
.set    NumberOfBattles, 0x02001F6C

.global ShopTierAmount
.set    ShopTierAmount, 0x08b30950

.global BattleNumConditionFlag
.set    BattleNumConditionFlag, 0x08b30951

.global ShopUnlockList
.set    ShopUnlockList, (0x08b30954-1) @ Index starts at 1

@ ShopUnlockList lists which tier each item becomes available at. Since item ids start at 1 the list also starts at index 1.
@ BattleNumConditionFlag enables unlocking the first 2 upgrades by fighting battles, but this does not count towards further upgrades.

.global ShopUpgradeTempItem
.set ShopUpgradeTempItem, 0x01bd


@ Receive Items
.global Receive_item_address
.set Receive_item_address, 0x0201f46c

.global Receive_item_offset
.set Receive_item_offset, 0x0201f474

.global Receive_write_normal_item
.set Receive_write_normal_item, 0x08039ef8

.global Receive_write_mission_item
.set Receive_write_mission_item, 0x08039f68

.global Receive_item_write_after
.set Receive_item_write_after, 0x08039fc0

.global Receive_items_give_after
.set Receive_items_give_after, 0x0803a624


.global Receive_item_next_continue
.set Receive_item_next_continue, 0x0803a55c @ If next item is not 0

.global Receive_item_next_end
.set Receive_item_next_end, 0x0803a5b0 @ If next item is 0

@ Shared item data

.global Items_for_display_only @ List of items that should not go into inventory
.set Items_for_display_only, 0x08b31100
