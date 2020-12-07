package Zing::Simple;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Process';

use Zing::Logic::Simple;

# VERSION

# BUILDERS

fun new_logic($self) {
  my $debug = $self->env->debug;
  Zing::Logic::Simple->new(debug => $debug, process => $self)
}

1;
