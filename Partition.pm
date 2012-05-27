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
	$self->{'fs'} = undef;

	# Process params.
	set_params($self, @params);

	# Load informations from CSV format.
	if (! defined $self->{'fs'}) {
		$self->_load;
	}

	# Object.
	return $self;
}

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

# Load information.
sub _load {
	my $self = shift;

	# Load module and create object.
	if (! $self->{'csv'}) {
		require Text::CSV;
		$self->{'csv'} = Text::CSV->new;
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

		# Save values from CSV.
		$self->{'fs'}->{$cols[0]} = {
			'introduction' => $cols[1],
			'support' => $cols[2],
			'description' => $cols[3],
		}
	}

	return;
}

1;

__DATA__
Partition ID,Introduction,Support,Description
0x00,IBM,All,Empty partition entry
0x01,Microsoft,DOS 2.0+,"FAT12 as primary partition in first physical 32 MB of disk or as logical drive anywhere on disk (else use 0x06 instead)"
0x02,"Microsoft, SCO",XENIX,XENIX root
0x03,"Microsoft, SCO",XENIX,XENIX usr
