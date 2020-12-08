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

method poll() {
  return Zing::Poll->new(repo => $self, name => $self->name);
}

method recv() {
  return $self->store->lpull($self->term);
}

method send(HashRef $value) {
  return $self->store->rpush($self->term, $value);
}

method term() {
  return $self->app->term($self)->pubsub;
}

1;
