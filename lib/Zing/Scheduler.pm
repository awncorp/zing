package Zing::Scheduler;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Launcher';

# VERSION

# METHODS

method queues() {
  ['$scheduled']
}

1;
