package Zing::KeyVal;

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
  return $self->store->recv($self->term($key));
}

method send(Str $key, HashRef $val) {
  return $self->store->send($self->term($key), $val);
}

method term(Str @keys) {
  return $self->next::method('keyval', @keys);
}

1;
