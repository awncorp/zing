package Zing::Logic::Single;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Logic';

# VERSION

# METHODS

method handle_perform_event() {
  my $process = $self->process;

  my $result = $self->next::method;

  $process->shutdown;

  return $result;
}

1;
