package Zing::Ring;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Process';

# VERSION

# ATTRIBUTES

has 'processes' => (
  is => 'ro',
  isa => 'ArrayRef[Process]',
  req => 1
);

# METHODS

method destroy() {
  $_->destroy for @{$self->processes};

  return $self->next::method;
}

method execute() {
  $_->started(time) for @{$self->processes};

  $self->next::method;

  $_->destroy->stopped(time) for @{$self->processes};

  return $self;
}

method exercise() {
  $_->started(time) for @{$self->processes};

  $self->next::method;

  $_->destroy->stopped(time) for @{$self->processes};

  return $self;
}

method perform() {
  my $position = ($self->{position} ||= 0)++;

  my $process = $self->processes->[$position];

  $process->loop->exercise($process);

  delete $self->{position} if ($self->{position} + 1) > @{$self->processes};

  return $self;
}

method shutdown() {
  $_->shutdown for @{$self->processes};

  return $self->next::method;
}

method winddown() {
  $_->winddown for @{$self->processes};

  return $self->next::method;
}

1;
