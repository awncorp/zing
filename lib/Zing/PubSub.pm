package Zing::PubSub;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Repo';

use Zing::Poll;

# VERSION

# METHODS

method poll(Str $key) {
  return Zing::Poll->new(repo => $self, name => $key);
}

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
