package Zing::Kernel;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Watcher';

use Zing::Channel;
use Zing::Logic::Kernel;

use FlightRecorder;

# VERSION

# ATTRIBUTES

has 'journal' => (
  is => 'ro',
  isa => 'Channel',
  new => 1,
);

fun new_journal($self) {
  Zing::Channel->new(name => 'journal')
}

has 'scheme' => (
  is => 'ro',
  isa => 'Scheme',
  req => 1,
);

# BUILDERS

fun new_logic($self) {
  Zing::Logic::Kernel->new(process => $self);
}

# METHODS

method perform() {
  if (my $info = $self->journal->recv) {
    my $log = $self->log;

    my $from = $info->{from};
    my $data = $info->{data};

    $data->{auto} = $log->auto;
    $data->{format} = $log->format;
    $data->{level} = $log->level;

    my $logger = FlightRecorder->new($data);

    if (my $lines = $logger->simple->generate) {
      print STDOUT $from, ' ', $lines, "\n";
    }
  }
}

1;
