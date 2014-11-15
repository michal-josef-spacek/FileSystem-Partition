# Pragmas.
use strict;
use warnings;

# Modules.
use FileSystem::Partition;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($FileSystem::Partition::VERSION, 0.01, 'Version.');
