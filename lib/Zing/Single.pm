package Zing::Single;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

use Zing::Logic::Single;

extends 'Zing::Process';

# VERSION

# BUILDERS

fun new_logic($self) {
  Zing::Logic::Single->new(process => $self)
}

1;
