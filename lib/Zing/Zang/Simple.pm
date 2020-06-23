package Zing::Zang::Simple;

use 5.014;

use strict;
use warnings;

use registry;
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Simple';

# VERSION

# ATTRIBUTES

has 'on_perform' => (
  is => 'ro',
  isa => 'Maybe[CodeRef]',
  opt => 1,
);

method perform(@args) {
  return $self if !$self->on_perform;

  $self->on_perform->($self, @args);

  return $self;
}

1;