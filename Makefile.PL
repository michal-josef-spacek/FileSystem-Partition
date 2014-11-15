# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Perl module filesystem partition identification.';
author 'Michal Spacek <skim@cpan.org>';
license 'bsd';
name 'FileSystem-Partition';
requires 'Class::Utils' => 0.06;
requires 'Error::Pure' => 0.17;
readme_from 'Partition.pm';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=FileSystem-Partition';
resources 'homepage' => 'https://github.com/tupinek/FileSystem-Partition';
resources 'repository' => 'git://github.com/tupinek/FileSystem-Partition';
test_requires 'English' => 0;
test_requires 'File::Object' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
