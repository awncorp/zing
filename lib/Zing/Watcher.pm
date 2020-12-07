package Zing::Watcher;

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
  my $debug = $self->env->debug;
  Zing::Logic::Watcher->new(debug => $debug, process => $self)
}

1;
