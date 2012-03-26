# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Perl module filesystem partition identification.';
author 'Michal Špaček <skim@cpan.org>';
license 'bsd';
name 'Filesystem-Partition';
#requires 'Cwd' => 0;
#requires 'English' => 0;
#requires 'Exporter' => 0;
#requires 'List::MoreUtils' => 0;
#requires 'Readonly' => 0;
resources 'repository' => {
	'url' => 'git://github.com/tupinek/Filesystem-Partition',
	'web' => 'https://github.com/tupinek/Filesystem-Partition',
	'type' => 'git',
};
#test_requires 'Cwd' => 0;
#test_requires 'English' => 0;
#test_requires 'File::Spec::Functions' => 0;
#test_requires 'FindBin' => 0;
#test_requires 'Test::More' => 0;
#test_requires 'Test::Pod' => 0;
#test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
