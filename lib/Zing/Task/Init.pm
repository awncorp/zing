package Zing::Task::Init;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Task';

# VERSION

# METHODS

method process() {
  $self->log->info("init" => time);

  return $self;
}

1;
