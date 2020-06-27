package Zing::Ringer;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

extends 'Zing::Ring';

# VERSION

# ATTRIBUTES

has 'processes' => (
  is => 'ro',
  isa => 'ArrayRef[Process]',
  mod => 1,
  new => 1,
  opt => 1,
);

fun new_processes($self) {
  [map $self->reify($_), @{$self->schemes}]
}

has 'schemes' => (
  is => 'ro',
  isa => 'ArrayRef[Scheme]',
  req => 1,
);

# METHODS

method reify(Scheme $scheme) {
  my $class = $scheme->[0];
  my $space = Data::Object::Space->new($class);
  my $build = $space->build(@{$scheme->[1]});

  return $build;
}

1;