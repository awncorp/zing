package Zing::Mailbox;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::PubSub';

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
  mod => 1,
);

fun new_name($self) {
  $self->process->name
}

has 'process' => (
  is => 'ro',
  isa => 'Process',
  req => 1,
);

# BUILDERS

fun new_target($self) {
  'global'
}

# METHODS

method recv() {
  return $self->store->pull($self->term);
}

method message(HashRef $val) {
  +{ data => $val, from => $self->name };
}

method reply(HashRef $bag, HashRef $val) {
  return $self->send($bag->{from}, $val);
}

method send(Str $key, HashRef $val) {
  return $self->store->push($self->term($key), $self->message($val));
}

method size() {
  return $self->store->size($self->term);
}

method term(Maybe[Str] $name) {
  return $self->global($name || $self->name, 'mailbox');
}

1;
