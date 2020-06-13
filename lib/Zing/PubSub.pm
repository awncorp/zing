package Zing::PubSub;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Repo';

# VERSION

# METHODS

method recv(Str $key) {
  return $self->store->pull($self->term('queue', $key));
}

method send(Str $key, HashRef $val) {
  return $self->store->push($self->term('queue', $key), $val);
}

1;
