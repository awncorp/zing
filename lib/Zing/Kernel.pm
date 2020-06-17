package Zing::Kernel;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Watcher';

# VERSION

# ATTRIBUTES

has 'scheme' => (
  is => 'ro',
  isa => 'Scheme',
  req => 1,
);

# METHODS

sub perform {
  warn time, ' ', 'kernel running';
}

1;
