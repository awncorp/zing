package Zing::Launcher;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Zing::Logic::Watcher;

extends 'Zing::Worker';

# VERSION

# METHODS

method handle(Str $name, HashRef $data) {
  $self->spawn($data->{scheme}) if $data->{scheme};
}

1;
