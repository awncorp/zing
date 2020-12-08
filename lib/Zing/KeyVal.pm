package Zing::KeyVal;

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

method poll() {
  return Zing::Poll->new(repo => $self, name => $self->name);
}

method recv() {
  return $self->store->recv($self->term);
}

method send(HashRef $value) {
  return $self->store->send($self->term, $value);
}

method term() {
  return $self->app->term($self)->keyval;
}

1;
