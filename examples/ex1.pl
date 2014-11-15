#!/usr/bin/env perl

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