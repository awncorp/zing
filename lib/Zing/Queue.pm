package Zing::Queue;

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
  req => 1,
);

has 'server' => (
  is => 'ro',
  isa => 'Server',
  new => 1,
);

fun new_server($self) {
  Zing::Server->new
}

# METHODS

method recv() {
  return $self->store->pull($self->term);
}

method send(Message $val) {
  return $self->store->push($self->term, $val->serialize);
}

method size() {
  return $self->store->size($self->term);
}

method term(Str @keys) {
  return join(':', $self->server->name, 'queue', $self->name);
}

1;
