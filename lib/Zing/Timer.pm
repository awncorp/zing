package Zing::Timer;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Logic::Timer;

extends 'Zing::Process';

# VERSION

# ATTRIBUTES

has 'on_schedules' => (
  is => 'ro',
  isa => 'Maybe[CodeRef]',
  opt => 1,
);

# BUILDERS

fun new_logic($self) {
  my $debug = $self->env->debug;
  Zing::Logic::Timer->new(debug => $debug, process => $self)
}

# METHODS

method schedules(@args) {
  return $self if !$self->on_schedules;

  my $schedules = $self->on_schedules->($self, @args);

  return $schedules;
}

1;
