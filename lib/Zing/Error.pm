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

# FUNCTIONS

fun error() {
  # do something ...

  return;
}

1;