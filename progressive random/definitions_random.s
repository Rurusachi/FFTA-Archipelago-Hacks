.macro SET_FUNC name, value
	.global \name
	.type   \name, %function
	.set    \name, \value
.endm

SET_FUNC Begin_progressive, (0x08b30400+1)
SET_FUNC EndRoutine, (0x0804618c+1)
SET_FUNC ItemReward, (0x080460b0+1)
SET_FUNC CardReward, (0x08046140+1)

.global MagicModuloNumber
.set  MagicModuloNumber, 1796509867

.global ProgressiveCounter
.set    ProgressiveCounter, 0x02001932 @ Seems to be unused memory space, we use 4 bytes (0x02001932 - 0x02001935)

.global InitializationBytePointer
.set    InitializationBytePointer, 0x02001936

.global CurrentState
.set    CurrentState, 0x02001938

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
