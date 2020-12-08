package Zing::PubSub;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Repo';

use Zing::Poll;
use Zing::Term;

# VERSION

# METHODS

method poll(Str $key) {
  return Zing::Poll->new(repo => $self, name => $key);
}

method recv(Str $key) {
  return $self->store->lpull($self->term($key));
}

method send(Str $key, HashRef $val) {
  return $self->store->rpush($self->term($key), $val);
}

method term(Str @keys) {
  return $self->app->term($self, @keys)->pubsub;
}

1;
