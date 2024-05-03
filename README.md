# FFTA-Archipelago-Hacks
This repository contains hacks created for the [Archipelago FFTA world](https://github.com/spicynun/Archipelago/tree/ffta).
The "progressive random" hack is made to be inserted with Event Assembler (with ColorzCore), and Lyn. 
It changes how item rewards for missions are stored, so it is not usable without Archipelago or modifying the mission rewards in some other way

The "progressive shop" hack adds progressive shop upgrades to the "progressive random" hack. 
Like the "progressive random" hack it requires outside modification from Archipelago or similar to work. 
It also requires part of [Leonarth's Engine Hacks](https://github.com/LeonarthCG/FFTA_Engine_Hacks) to be applied first as it hooks into the end of [Leonarth's shopBuyList code](https://github.com/LeonarthCG/FFTA_Engine_Hacks/blob/master/Engine%20Hacks/newInventory/ASM/shopBuyList.s). (This is already part of the Archipelago base patch)

The "FFTA rewards notes" folder contains assembly code and notes for my two previous hacks. They are not made for Event Assembler, they were inserted manually.
The "progressive random" hack is based on the "6 reward" version. The "6 rewards version" also changes how item rewards for missions are stored.

# Instructions (progressive random)
1. Download [Event Assembler](http://feuniverse.us/t/event-assembler/1749)
2. Download [ColorzCore.exe](https://github.com/FireEmblemUniverse/ColorzCore/blob/master/ColorzCore/bin/Release/ColorzCore.exe)
3. Replace the core.exe from Event Assembler with ColorzCore.exe
4. Download [Lyn](https://github.com/StanHash/lyn), and place it in Event Assembler's Tools folder
5. (Optional, if you want to change the code) Download [DevkitArm](https://devkitpro.org/wiki/Getting_Started)
6. (Optional, if the code was changed) Assemble the ".s" files into ".elf" files with "Assemble elf.bat"
7. Run the following command from Event Assembler's folder: `Core A FE8 -input:"path/to/progressive_random.event" -output:"path/to/FFTA_hack.gba"` (This overwrites the .gba file)
