package Zing::Error;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Data::Object::Exception';
extends 'Exporter';

# VERSION

our @EXPORT = qw(error);

# FUNCTIONS

fun error($self, $type) {

  return;
}

fun unknown_error(Object :$context) {

  return Zing::Error->new(context => $context);
}

1;