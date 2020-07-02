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

  my $fork = $self->spawn($data->{scheme});

  do {0} while $fork->sanitize;

  return $self;
}

1;
