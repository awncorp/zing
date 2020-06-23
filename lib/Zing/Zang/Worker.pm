package Zing::Zang::Worker;

use 5.014;

use strict;
use warnings;

use registry;
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Worker';

# VERSION

# ATTRIBUTES

has 'on_handle' => (
  is => 'ro',
  isa => 'Maybe[CodeRef]',
  opt => 1,
);

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

has 'queues' => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  req => 1,
);

# METHODS

method handle(@args) {
  return $self if !$self->on_handle;

  $self->on_handle->($self, @args);

  return $self;
}

method receive(@args) {
  return $self if !$self->on_receive;

  $self->on_receive->($self, @args);

  return $self;
}

method perform(@args) {
  return $self if !$self->on_perform;

  $self->on_perform->($self, @args);

  return $self;
}

1;