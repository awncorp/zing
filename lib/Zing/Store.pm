package Zing::Store;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Entity';

# VERSION

# ATTRIBUTES

has 'encoder' => (
  is => 'ro',
  isa => 'Encoder',
  new => 1,
);

fun new_encoder($self) {
  require Zing::Encoder; Zing::Encoder->new;
}

# METHODS

sub args {
  map +($$_[0], $#{$$_[1]} ? $$_[1] : $$_[1][0]),
  map [$$_[0], [split /\|/, $$_[1]]],
  map [split /=/], split /,\s*/,
  $_[1] || ''
}

method decode(Str $data) {
  return $self->encoder->decode($data);
}

method drop(Any @args) {
  $self->throw(error_not_implemented($self, 'drop'));
}

method encode(HashRef $data) {
  return $self->encoder->encode($data);
}

method keys(Any @args) {
  $self->throw(error_not_implemented($self, 'keys'));
}

method lpull(Any @args) {
  $self->throw(error_not_implemented($self, 'lpull'));
}

method lpush(Any @args) {
  $self->throw(error_not_implemented($self, 'lpush'));
}

method recv(Any @args) {
  $self->throw(error_not_implemented($self, 'recv'));
}

method rpull(Any @args) {
  $self->throw(error_not_implemented($self, 'rpull'));
}

method rpush(Any @args) {
  $self->throw(error_not_implemented($self, 'rpush'));
}

method send(Any @args) {
  $self->throw(error_not_implemented($self, 'send'));
}

method size(Any @args) {
  $self->throw(error_not_implemented($self, 'size'));
}

method slot(Any @args) {
  $self->throw(error_not_implemented($self, 'slot'));
}

sub term {
  shift; return join(':', @_);
}

method test(Any @args) {
  $self->throw(error_not_implemented($self, 'test'));
}

# ERRORS

fun error_not_implemented(Object $object, Str $method) {
  code => 'error_not_implemented',
  message => "@{[ref($object)]} method \"$method\" not implemented",
}

1;
