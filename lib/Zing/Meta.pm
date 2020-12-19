package Zing::Meta;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::KeyVal';

# VERSION

# METHODS

method term() {
  return $self->app->term($self)->meta;
}

1;
