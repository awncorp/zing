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

method recv(Str $key) {
  return $self->store->recv($self->term($key));
}

method send(Process $val) {
  return $self->store->send($self->term($val->name), $val->registration);
}

method term(Str @keys) {
  return $self->next::method('registry', @keys);
}

1;
