package Zing::Timer;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Zing::Logic::Timer;

extends 'Zing::Process';

# VERSION

# BUILDERS

fun new_logic($self) {
  Zing::Logic::Timer->new(process => $self)
}

1;
