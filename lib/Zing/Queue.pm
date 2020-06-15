package Zing::Queue;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::PubSub';

# VERSION

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

method term() {
  return join(':', $self->server->name, 'queue', $self->name);
}

1;
