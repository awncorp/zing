package Zing::Zang::Spawner;

use 5.014;

use strict;
use warnings;

use registry;
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Spawner';

# VERSION

# ATTRIBUTES

has 'queues' => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  req => 1,
);

1;
