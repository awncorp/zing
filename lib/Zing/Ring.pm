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

has processes => (
  is => 'ro',
  isa => 'ArrayRef[Process]',
  req => 1
);

# METHODS

method perform() {
  my $position = ($self->{position} ||= 0)++;

  $self->processes->[$position]->exercise;

  delete $self->{position} if ($self->{position} + 1) > @{$self->processes};

  return;
}

method destroy() {
  $_->destroy for @{$self->processes};

  return $self->next::method;
}

method shutdown() {
  $_->shutdown for @{$self->processes};

  return $self->next::method;
}

1;
