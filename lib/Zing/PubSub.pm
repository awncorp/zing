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
  return $self->store->pull($self->term($key));
}

method send(Str $key, HashRef $val) {
  return $self->store->push($self->term($key), $val);
}

method term(Str @keys) {
  return $self->next::method('pubsub', @keys);
}

1;
