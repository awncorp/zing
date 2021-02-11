package Zing::Worker;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Logic::Worker;

extends 'Zing::Process';

# VERSION

# ATTRIBUTES

has 'on_handle' => (
  is => 'ro',
  isa => 'Maybe[CodeRef]',
  opt => 1,
);

has 'on_queues' => (
  is => 'ro',
  isa => 'Maybe[CodeRef]',
  opt => 1,
);

# BUILDERS

fun new_logic($self) {
  my $debug = $self->env->debug;
  Zing::Logic::Worker->new(debug => $debug, process => $self)
}

# METHODS

method handle(@args) {
  return $self if !$self->on_handle;

  $self->on_handle->($self, @args);

  return $self;
}

method queues(@args) {
  return $self if !$self->on_queues;

  my $queues = $self->on_queues->($self, @args);

  return $queues;
}

1;
