package FileSystem::Partition;

# Pragmas.
use strict;
use warnings;

# Modules.

# Version.
our $VERSION = 0.01;

1;

__END__

__DATA__
Partition ID,Introduction,Support,Description
0x00,IBM,All,Empty partition entry
0x01,Microsoft,DOS 2.0+,"FAT12 as primary partition in first physical 32 MB of disk or as logical drive anywhere on disk (else use 0x06 instead)"
0x02,"Microsoft, SCO",XENIX,XENIX root
0x03,"Microsoft, SCO",XENIX,XENIX usr
TODO
