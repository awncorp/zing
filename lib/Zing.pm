package Zing;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Kernel';

# VERSION

# ATTRIBUTES

has 'scheme' => (
  is => 'ro',
  isa => 'Scheme',
  req => 1,
);

# METHODS

method start() {
  return $self->execute;
}

1;
