Instruction:
1. Start mksdcard.bat

For Dolphin with default Global User Directory - more information here: https://wiki.dolphin-emu.org/index.php?title=Controlling_the_Global_User_Directory
> Alternatively, place \Virtual SD Card Maker\ folder under Dolphin profile not in default location of Global User Directory.
> Otherwise, move sd.raw to \Dolphin Emulator\Wii\ yourself if created on Desktop.

Review codes by opening mksdcard.bat in Notepad when needed.

The virtual SD card can be mounted using ImDisk Virtual Disk Driver - http://www.ltr-data.se/opencode.html/#ImDisk

Quick guide for mounting and editing the virtual SD card with the ImDisk Virtual Disk Driver:
1. Right-click on sd.raw file then click "Mount as ImDisk Virtual Disk" from the context menu.
2. Check box "Removable media" then hit "OK". The predefined drive letter and everything else will do just fine. 
 > The virtual SD card will now appear as "Removable Disk" in which the native Explorer window can read and write in there.
3. When done editing the virtual SD card, simply unmount it by right-click on the "Removable Disk" then click "Unmount ImDisk Virtual Disk" from the context menu. 
 > The virtual SD card must be dismounted before using with Dolphin.

~Lucario

Thank you:
- ANON4453 for Easy Dolphin SDCard Maker concept.
- ifrit05 for his original batch file (Dolphin SDCard Maker v1.0.bat).
- mksdcard.exe has been obtained from: http://developer.android.com/sdk/index.html#Other