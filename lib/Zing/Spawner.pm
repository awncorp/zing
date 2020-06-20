package Zing::Spawner;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Worker';

# VERSION

# METHODS

method handle(Str $name, HashRef $data) {
  return $self if !$data->{scheme};

  $self->spawn($data->{scheme});

  my $class = $data->{scheme}[0];

  ($self->{launched}{$class} ||= 0)++;

  # due to the unforeseen (but expected) consequences of loading too many
  # packages into memory, a launcher should kill itself after loading some
  # arbitrary number of packages
  $self->winddown if keys %{$self->{launched}} > 50;

  return $self;
}

1;
