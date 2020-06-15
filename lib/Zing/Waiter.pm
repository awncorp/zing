package Zing::Waiter;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Zing::Logic::Waiter;

extends 'Zing::Process';

# VERSION

# BUILDERS

fun new_logic($self) {
  Zing::Logic::Waiter->new(process => $self)
}

1;
