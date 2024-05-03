.macro SET_FUNC name, value
	.global \name
	.type   \name, %function
	.set    \name, \value
.endm

SET_FUNC Begin_progressive, (0x08b30400+1)
SET_FUNC EndRoutine, (0x0804618c+1)
SET_FUNC ItemReward, (0x080460b0+1)
SET_FUNC CardReward, (0x08046140+1)
SET_FUNC Shop_init, (0x08b30800+1)

.global MagicModuloNumber
.set  MagicModuloNumber, 1796509867

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

.global ProgressiveShopLevel
.set    ProgressiveShopLevel, 0x02002AF7

.global NumberOfBattles
.set    NumberOfBattles, 0x02001F6C

.global ShopTierAmount
.set    ShopTierAmount, 0x08b30900

.global ShopUnlockListStart
.set    ShopUnlockListStart, 0x08b30904

@ Each tier of upgrades is a sequence of 2 byte item ids. 0000 marks the end of a sequence.
@ There is a 2 byte buffer between tiers.
@ ShopUnlockListStart is the address of the first item id in the first sequence.
@ Example where XXXX, YYYY, ZZZZ, AAAA, BBBB, CCCC are item ids, and FFFF is buffer:
@ XXXX YYYY ZZZZ 0000 FFFF AAAA BBBB CCCC 

.global checkEquippedamount
.set 	checkEquippedamount, 0x08b406dc

.global newItemTabs
.set 	newItemTabs, 0x08b405a4

.global ShopUpgradeTempItem
.set ShopUpgradeTempItem, 0x01bd
