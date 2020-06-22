package Zing::Simple;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Zing::Logic::Watcher;

extends 'Zing::Process';

# VERSION

# BUILDERS

fun new_logic($self) {
  Zing::Logic::Simple->new(process => $self)
}

1;
