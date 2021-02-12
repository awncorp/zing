package Zing::File;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Exporter';

our @EXPORT_OK = 'scheme';

# VERSION

# FUNCTIONS

fun scheme(Scheme | ArrayRef[Scheme | ArrayRef] $expr) {
  if (ref $expr->[0]) {
    return ['Zing::Ringer', [schemes => [map scheme($_), @$expr]], 1];
  }
  else {
    return ['Zing::Watcher', [on_scheme => sub { $expr }], 1];
  }
}

# METHODS

method interpret(Scheme | ArrayRef[Scheme | ArrayRef] $expr) {
  return scheme($expr);
}

1;
