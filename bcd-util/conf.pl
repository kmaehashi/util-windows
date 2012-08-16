# configuration for create-bcd.pl

# When running on English systems, change BCDEDIT_SYSTEM to 'a'!
$BCDEDIT_SYSTEM = 'b';

# Where to generate BCD file
$BCD_FILE = '%USERPROFILE%\Desktop\NewBCDFile';

# List of WIMs -- Never use `"` in name/path!
@IMAGES = (
		{	name => 'WinPE 3.0 + NIC Drivers',
			path => '\windows_pe_30_x86_boot.wim',
		},
		{	name => 'WinPE 2.1 + NIC Drivers',
			path => '\windows_pe_21_x86_boot.wim',
		},
		{	name => 'WinPE 2.1',
			path => '\windows_pe_21_x86_boot.wim',
		},
		{	name => 'ERD Commander for Vista (x64)',
			path => '\erd_commander_vista_x64.wim',
		},
		{	name => 'ERD Commander for Vista (x86)',
			path => '\erd_commander_vista_x86.wim',
		},
		{	name => 'ERD Commander for 7 (x64)',
			path => '\erd_commander_7_x64.wim',
		},
		{	name => 'ERD Commander for 7 (x86)',
			path => '\erd_commander_7_x86.wim',
		},
		{	name => 'Temporary Image',
			path => '\temp.wim',
		},
	);

# Misc. settings; no changes required
$RAMDISK_DEVICE = 'boot';
$RAMDISK_SDIPATH = '\boot\boot.sdi';

$BOOTMGR_DESCRIPTION = 'Windows Boot Manager';
$BOOTMGR_LOCALE = 'ja_JP';
$BOOTMGR_TIMEOUT = 30;

1; # DO NOT DELETE THIS LINE!
