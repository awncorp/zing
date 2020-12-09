package Zing::Encoder::Json;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Encoder';

use JSON -convert_blessed_universally;

# VERSION

# METHODS

method decode(Str $data) {
  return JSON->new->allow_nonref->convert_blessed->decode($data);
}

method encode(HashRef $data) {
  return JSON->new->allow_nonref->convert_blessed->encode($data);
}

1;
