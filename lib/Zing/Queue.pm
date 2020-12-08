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
  return $self->store->lpull($self->term);
}

method send(HashRef $val) {
  return $self->store->rpush($self->term, $val);
}

method size() {
  return $self->store->size($self->term);
}

method term() {
  return $self->app->term($self)->queue;
}

1;
