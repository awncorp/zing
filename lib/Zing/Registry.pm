package Zing::Registry;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::KeyVal';

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Str',
  def => 'default',
  mod => 1,
);

# METHODS

method drop(Process $proc) {
  return $self->store->drop($self->term($proc->name));
}

method recv(Process $proc) {
  return $self->store->recv($self->term($proc->name));
}

method send(Process $proc) {
  return $self->store->send($self->term($proc->name), $proc->registration);
}

method term(Str @keys) {
  return $self->next::method('registry', @keys);
}

1;
