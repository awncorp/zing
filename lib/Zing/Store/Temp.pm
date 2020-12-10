package Zing::Store::Temp;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Store::Disk';

# VERSION

# ATTRIBUTES

has root => (
  is => 'ro',
  isa => 'Str',
  init_arg => undef,
  new => 1,
);

fun new_root($self) {
  File::Spec->tmpdir
}

# BUILDERS

fun new_encoder($self) {
  require Zing::Encoder::Dump; Zing::Encoder::Dump->new;
}

1;
