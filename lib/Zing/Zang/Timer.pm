package Zing::Zang::Timer;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Timer';

# VERSION

# ATTRIBUTES

has 'on_perform' => (
  is => 'ro',
  isa => 'Maybe[CodeRef]',
  opt => 1,
);

has 'on_receive' => (
  is => 'ro',
  isa => 'Maybe[CodeRef]',
  opt => 1,
);

has 'schedules' => (
  is => 'ro',
  isa => 'ArrayRef[Schedule]',
  req => 1,
);

1;