package Zing::Zang::Watcher;

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

has 'scheme' => (
  is => 'ro',
  isa => 'Scheme',
  req => 1,
);

# METHODS

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
