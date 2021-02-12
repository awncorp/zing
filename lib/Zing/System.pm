package Zing::System;

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

has command => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  req => 1,
);

# METHODS

method perform(Any @args) {
  return exec(@{$self->command});
}

1;
