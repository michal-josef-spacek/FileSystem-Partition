package FileSystem::Partition;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# FileSystem structure.
	$self->{'fs'} = {};

	# Process params.
	set_params($self, @params);

	# Load informations from CSV format.
	if (! defined $self->{'fs'}) {
		$self->_load;
	}

	# Object.
	return $self;
}

# Get filesystem informations for one or all ids.
sub get {
	my ($self, $id) = @_;

	# Concrete ID.
	if ($id) {
		return $self->{'fs'}->{$id};

	# Return all.
	} else {
		return $self->{'fs'};
	}
}

# Get URL of Wikipedia page.
sub wikipedia_version {
	return 'http://en.wikipedia.org/w/index.php?title=Partition_type'.
		'&oldid=489195494';
}

# Load information.
sub _load {
	my $self = shift;

	# Load module and create object.
	if (! $self->{'csv'}) {
		require Text::CSV;
		$self->{'csv'} = Text::CSV->new({
			'binary' => 1,
		});
		if (! $self->{'csv'}) {
			err 'Cannot create Text::CSV object.',
				'Error', Text::CSV->error_diag;
		}
	}

	# Parse CSV data.
	while (my $line = <DATA>) {

		# Parse line.
		my $status = $self->{'csv'}->parse($line);
		if (! $status) {
			err "Cannot parse line '$line'.",
				'Error input', $self->{'csv'}->error_input;
		}
		my @cols = $self->{'csv'}->fields;
		if (@cols > 4) {
			err 'Bad number of information columns.',
				'Line', $line;
		}

		# Save values from CSV.
		if (! exists $self->{'fs'}->{$cols[0]}) {
			$self->{'fs'}->{$cols[0]} = [];
		}
		push @{$self->{'fs'}->{$cols[0]}}, {
			'introduction' => $cols[1],
			'support' => $cols[2],
			'description' => $cols[3],
		}
	}

	return;
}

1;

=pod

=encoding utf8

=head1 NAME

FileSystem::Partition - Perl module for filesystem informations.

=head1 SYNOPSIS

 use FileSystem::Partition;
 my $obj = FileSystem::Partition->new(%parameters);
 my $fs_hr = $obj->get([$id]);
 my $wikipedia_url = $obj->wikipedia_version;

=head1 SUBROUTINES

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=back

=item C<get([$id])>

 Get filesystem informations for one or all ids.
 Returns reference to hash structure with infor TODO

=item C<wikipedia_version()>

 TODO

=back

=head1 ERRORS

 new():
         Bad number of information columns.
                 Line: %s
         Cannot create Text::CSV object.
                 Error: %s
         Cannot parse line '%s'.
                 Error input: %s
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use FileSystem::Partition;

 # Object.
 my $obj = FileSystem::Partition->new;

 # Get URL of Wikipedia page..
 my $url = $obj->wikipedia_version;

 # Print to output.
 print "Wikipedia URL: $url\n";

 # Output:
 # Wikipedia URL: http://en.wikipedia.org/w/index.php?title=Partition_type&oldid=489195494

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Text::CSV>.

=head1 REPOSITORY

L<https://github.com/tupinek/FileSystem-Partition>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD 2-Clause License

=head1 VERSION

0.01

=cut

__DATA__
Partition ID,Introduction,Support,Description
0x00,IBM,All,Empty partition entry
0x01,Microsoft,DOS 2.0+,"FAT12 as primary partition in first physical 32 MB of disk or as logical drive anywhere on disk (else use 0x06 instead)"
0x02,"Microsoft, SCO",XENIX,XENIX root
0x03,"Microsoft, SCO",XENIX,XENIX usr
0x04,Microsoft,DOS 3.0+,"FAT16 with less than 65536 sectors (32 MB). As primary partition it must reside in first physical 32 MB of disk, or as logical drive anywhere on disk (else use 0x06 instead)."
0x05,IBM,"DOS (3.2) 3.3+","Extended partition with CHS addressing"
0x06,Compaq,"DOS 3.31+","FAT16B with 65536 or more sectors. It must reside in first physical 8 GB of disk, unless used for logical drives in an 0x0F extended partition (else use 0x0E instead). Also used for FAT12 and FAT16 volumes in primary partitions if they are not residing in first physical 32 MB of disk."
0x07,Microsoft,Windows NT,NTFS
0x07,"Microsoft, IBM","OS/2","IFS"
0x07,IBM,"OS/2, Windows NT",HPFS
0x07,Microsoft,Windows Embedded CE,exFAT
0x07,,Advanced Unix,
0x07,Quantum Software Systems,QNX 2,"QNX ""qnx"" (pre-1988 only)"
0x08,Commodore,Commodore MS-DOS 3.x,Logical sectored FAT12 or FAT16
0x08,IBM,OS/2 1.0-1.3,OS/2
0x08,IBM,AIX,AIX
0x08,Quantum Software Systems,QNX 1.x/2.x,"QNX ""qny"""
0x08,,SplitDrive,
0x08,Dell,,partition spanning multiple drives
0x09,IBM,AIX,AIX bootable
0x09,Quantum Software Systems,QNX 1.x/2.x,"QNX ""qnz"""
0x09,Mark Williams Company,Coherent,Coherent file system
0x0A,IBM,OS/2,OS/2 Boot Manager
0x0A,Mark Williams Company,Coherent,Coherent swap partition
0x0A,Unisys,OPUS,Open Parallel Unisys Server
0x0B,Microsoft,DOS 7.1+,FAT32 with CHS addressing
0x0C,Microsoft,DOS 7.1+,FAT32X with LBA
0x0E,Microsoft,DOS 7.0+,FAT16X with LBA
0x0F,Microsoft,DOS 7.0+,Extended partition with LBA
0x11,Leading Edge,Leading Edge MS-DOS 3.x,Logical sectored FAT12 or FAT16
0x11,IBM,OS/2 Boot Manager,Hidden FAT12 (corresponds with 0x01)
0x12,Compaq,,configuration partition (bootable FAT)
0x12,Compaq,Compaq Contura,hibernation partition
0x12,NCR,,diagnostics and firmware partition (bootable FAT)
0x12,Intel,,service partition (bootable FAT) (see 0x98)
0x12,IBM,,Rescue and Recovery partition
0x14,AST,AST MS-DOS 3.x,Logical sectored FAT12 or FAT16
0x14,IBM,OS/2 Boot Manager,Hidden FAT16 (corresponds with 0x04)
0x15,IBM,OS/2 Boot Manager,Hidden extended partition with CHS addressing (corresponds with 0x05)
0x16,IBM,OS/2 Boot Manager,Hidden FAT16B (corresponds with 0x06)
0x17,IBM,OS/2 Boot Manager,Hidden IFS (corresponds with 0x07)
0x17,IBM,OS/2 Boot Manager,Hidden HPFS (corresponds with 0x07)
0x17,IBM,OS/2 Boot Manager,Hidden NTFS (corresponds with 0x07)
0x17,IBM,OS/2 Boot Manager,Hidden exFAT (corresponds with 0x07)
0x18,AST,,AST Zero Volt Suspend or SmartSleep partition
0x19,Willow Schlanger,Willowtech Photon coS,Willowtech Photon coS (see 0x20)
0x1B,IBM,OS/2 Boot Manager,Hidden FAT32 (corresponds with 0x0B)
0x1C,IBM,OS/2 Boot Manager,Hidden FAT32X with LBA (corresponds with 0x0C)
0x1E,IBM,OS/2 Boot Manager,Hidden FAT16X with LBA (corresponds with 0x0E)
0x1F,IBM,OS/2 Boot Manager,Hidden extended partition with LBA addressing (corresponds with 0x0F)
0x20,Microsoft,Windows Mobile,Windows Mobile update XIP
0x20,Willow Schlanger,,Willowsoft Overture File System (OFS1) (see 0x19)
0x21,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0x21,Dave Poirier,Oxygen,FSo2 (Oxygen File System) (see 0x22)
0x22,Dave Poirier,Oxygen,Oxygen Extended Partition Table (see 0x21)
0x23,"Microsoft, IBM",,Reserved
0x23,Microsoft,Windows Mobile,Windows Mobile boot XIP
0x24,NEC,NEC MS-DOS 3.30,Logical sectored FAT12 or FAT16
0x25,Microsoft,Windows Mobile,Windows Mobile IMGFS
0x26,"Microsoft, IBM",,Reserved
0x27,Microsoft,Windows,Windows recovery environment (RE) partition (hidden NTFS partition type 0x07)
0x27,Acer,PQservice,FAT32 or NTFS rescue partition
0x27,,MirOS BSD,MirOS partition
0x27,,RooterBOOT,"RooterBOOT kernel partition (contains a raw ELF Linux kernel, no filesystem)"
0x2A,Kurt Skauen,AtheOS,"AtheOS file system (AthFS, AFS)"
0x2B,,,"SyllableSecure (SylStor), a variant of AthFS"
0x31,"Microsoft, IBM",,Reserved
0x32,Alien Internet Services,NOS,
0x33,"Microsoft, IBM",,Reserved
0x34,"Microsoft, IBM",,Reserved
0x35,IBM,OS/2 Warp Server / eComStation,"JFS (OS/2 implementation of AIX Journaling Filesystem), non-bootable"
0x36,"Microsoft, IBM",,Reserved
0x38,Timothy Williams,THEOS,"THEOS version 3.2, 2 GB partition"
0x39,Bell Labs,Plan 9,Plan 9 edition 3 partition (sub-partitions described in second sector of partition)
0x39,Timothy Williams,THEOS,THEOS version 4 spanned partition
0x3A,Timothy Williams,THEOS,"THEOS version 4, 4 GB partition"
0x3B,Timothy Williams,THEOS,THEOS version 4 extended partition
0x3C,PowerQuest,PartitionMagic,PqRP (PartitionMagic in progress)
0x3D,PowerQuest,PartitionMagic,Hidden NetWare
0x40,PICK Systems,PICK,PICK R83
0x40,VenturCom,Venix,Venix 80286
0x41,,Personal RISC,Personal RISC Boot
0x41,Linux,Linux,Old Linux/Minux (disk shared with DR DOS 6.0) (corresponds with 0x81)
0x41,PowerPC,PowerPC,PPC PReP (Power PC Reference Platform) Boot
0x42,Peter Gutmann,SFS,Secure Filesystem (SFS)
0x42,Linux,Linux,Old Linux swap (disk shared with DR DOS 6.0) (corresponds with 0x82
0x42,Microsoft,Windows 2000,Dynamic extended partition marker
0x43,Linux,Linux,Old Linux native (disk shared with DR DOS 6.0) (corresponds with 0x83)
0x44,Wildfile,GoBack,"Norton GoBack, WildFile GoBack, Adaptec GoBack, Roxio GoBack"
0x45,Priam,,Priam (see also 0x5C)
0x45,,,Boot-US boot manager
0x45,"Jochen Liedtke, GMD",EUMEL/ELAN,EUMEL/ELAN
0x46,"Jochen Liedtke, GMD",EUMEL/ELAN,EUMEL/ELAN
0x47,"Jochen Liedtke, GMD",EUMEL/ELAN,EUMEL/ELAN
0x48,"Jochen Liedtke, GMD",EUMEL/ELAN,EUMEL/ELAN
0x4A,Mark Aitchison,ALFS/THIN,ALFS/THIN advanced lightweight filesystem for DOS
0x4C,"ETH Zürich",ETH Oberon,Aos (A2) filesystem (76)
0x4D,Quantum Software Systems,QNX 4.x,Primary QNX POSIX volume on disk
0x4E,Quantum Software Systems,QNX 4.x,Secondary QNX POSIX volume on disk
0x4F,Quantum Software Systems,QNX 4.x,Tertiary QNX POSIX volume on disk
0x4F,ETH Zürich,ETH Oberon,Nat filesystem (79)
0x50,ETH Zürich,ETH Oberon,Alternative Nat filesystem (80)
0x50,OnTrack,DiskManager,Read-only partition (old)
0x50,,LynxOS,Lynx RTOS
0x51,Novell,,
0x51,OnTrack,DiskManager 6,Read-write partition (Aux 1)
0x52,,,CP/M
0x52,Microport,System V/AT,
0x53,OnTrack,DiskManager 6,Aux 3
0x54,OnTrack,DiskManager 6,Dynamic Drive Overlay (DDO)
0x55,MicroHouse / StorageSoft,EZ-Drive,"EZ-Drive, Maxtor, MaxBlast, or DriveGuide INT 13h redirector volume"
0x56,AT&T,AT&T MS-DOS 3.x,Logical sectored FAT12 or FAT16
0x56,MicroHouse / StorageSoft,EZ-Drive,DiskManager partition converted to EZ-BIOS
0x56,Golden Bow,VFeature,VFeature partitionned volume
0x57,Novell,,VNDI partition
0x57,MicroHouse / StorageSoft,DrivePro,
0x5C,Priam,EDISK,Priam EDisk Partitioned Volume (see also 0x45)
0x64,Novell,NetWare,NetWare File System 286
0x65,Novell,NetWare,NetWare File System 386
0x78,Geurt Vos,,XOSL bootloader filesystem
0x80,Andrew Tanenbaum,Minix,Old Minix file system
0x81,Andrew Tanenbaum,Minix,MINIX file system (corresponds with 0x41)
0x82,GNU/Linux,,Linux swap space (corresponds with 0x42)
0x82,Sun Microsystems,,Solaris
0x83,GNU/Linux,,Any native Linux file system (corresponds with 0x43)
0x84,Microsoft,,"Hibernation (suspend to disk, S2D)"
0x85,GNU/Linux,,Linux extended
0x86,Microsoft,,Legacy FT FAT16
0x87,Microsoft,,Legacy FT NTFS
0x88,GNU/Linux,,Linux plaintext
0x8B,Microsoft,,Legacy FT FAT32
0x8C,Microsoft,,Legacy FT FAT32 with LBA
0x8D,FreeDOS,Free FDISK,Hidden FAT12 (corresponds with 0x01)
0x8E,GNU/Linux,Linux,Linux LVM
0x90,FreeDOS,Free FDISK,Hidden FAT16 (corresponds with 0x04)
0x91,FreeDOS,Free FDISK,Hidden extended partition with CHS addressing (corresponds with 0x05)
0x92,FreeDOS,Free FDISK,Hidden FAT16B (corresponds with 0x06)
0x97,FreeDOS,Free FDISK,Hidden FAT32 (corresponds with 0x0B)
0x98,FreeDOS,Free FDISK,Hidden FAT32X (corresponds with 0x0C)
0x98,Intel,,service partition (bootable FAT) (see 0x12)
0x9A,FreeDOS,Free FDISK,Hidden FAT16X (corresponds with 0x0E)
0x9B,FreeDOS,Free FDISK,Hidden extended partition with LBA (corresponds with 0x0F)
0xA0,Hewlett-Packard,,Diagnostic partition for HP laptops
0xA1,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0xA3,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0xA4,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0xA5,FreeBSD,BSD,BSD slice
0xA6,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0xA6,OpenBSD,OpenBSD,OpenBSD slice
0xA7,NeXT,,NeXTSTEP
0xA8,Apple,,Apple Mac OS X
0xA9,NetBSD,NetBSD,NetBSD slice
0xAB,Apple,,Apple Mac OS X boot
0xAF,Apple,,Apple Mac OS X HFS and HFS+
0xB1,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0xB1,QNX Software Systems,QNX 6.x,QNX Neutrino power-safe file system
0xB2,QNX Software Systems,QNX 6.x,QNX Neutrino power-safe file system
0xB3,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0xB3,QNX Software Systems,QNX 6.x,QNX Neutrino power-safe file system
0xB4,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0xB6,Hewlett Packard,,HP Volume Expansion (SpeedStor)
0xC0,"Novell, IMS","DR-DOS, Multiuser DOS, REAL/32",Secured FAT partition (smaller than 32 MB)
0xC1,Digital Research,DR DOS 6.0+,Secured FAT12 (corresponds with 0x01)
0xC4,Digital Research,DR DOS 6.0+,Secured FAT16 (corresponds with 0x04)
0xC5,Digital Research,DR DOS 6.0+,Secured extended partition with CHS addressing (corresponds with 0x05)
0xC6,Digital Research,DR DOS 6.0+,Secured FAT16B (corresponds with 0x06)
0xCB,Caldera,DR-DOS 7.0x,Secured FAT32 (corresponds with 0x0B)
0xCC,Caldera,DR-DOS 7.0x,Secured FAT32X (corresponds with 0x0C)
0xCE,Caldera,DR-DOS 7.0x,Secured FAT16X (corresponds with 0x0E)
0xCF,Caldera,DR-DOS 7.0x,Secured extended partition with LBA (corresponds with 0x0F)
0xD0,"Novell, IMS","Multiuser DOS, REAL/32",Secured FAT partition (larger than 32 MB)
0xD1,Novell,Multiuser DOS,Secured FAT12 (corresponds with 0x01)
0xD4,Novell,Multiuser DOS,Secured FAT16 (corresponds with 0x04)
0xD5,Novell,Multiuser DOS,Secured extended partition with CHS addressing (corresponds with 0x05)
0xD6,Novell,Multiuser DOS,Secured FAT16B (corresponds with 0x06)
0xDB,Digital Research,"CP/M-86, Concurrent CP/M-86, Concurrent DOS","CP/M-86, Concurrent CP/M-86, Concurrent DOS"
0xDE,Dell,,Dell diagnostic partition
0xE5,Tandy,Tandy MS-DOS,Logical sectored FAT12 or FAT16
0xEB,Be Inc.,"BeOS, Haiku",BFS
0xED,Matthias Paul,Sprytix,EDC
0xEE,Microsoft,EFI,EFI protective MBR
0xEF,Intel,EFI,EFI system partition can be a FAT file system
0xF2,"Sperry IT, Unisys, Digital Research","Sperry IT MS-DOS 3.x, Unisys MS-DOS 3.3, Digital Research DOS Plus 2.1",Logical sectored FAT12 or FAT16
0xFB,VMware,VMware,VMware VMFS
0xFC,VMware,VMware,VMware VMKCORE
0xFD,GNU/Linux,Linux,Linux RAID auto
0xFE,IBM,,IBM IML partition
0xFF,Microsoft,XENIX,XENIX bad block table
