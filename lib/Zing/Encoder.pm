package Zing::Encoder;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

# VERSION

# METHODS

method decode(HashRef $data) {
  return $data;
}

method encode(HashRef $data) {
  return $data;
}

1;
