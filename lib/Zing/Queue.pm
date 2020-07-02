package Zing::Queue;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::PubSub';

use Zing::Term;

# VERSION

# METHODS

method recv() {
  return $self->store->pull($self->term);
}

method send(HashRef $val) {
  return $self->store->push($self->term, $val);
}

method size() {
  return $self->store->size($self->term);
}

method term() {
  return Zing::Term->new($self)->queue;
}

1;
