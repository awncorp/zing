package Zing::Data;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::KeyVal';

# VERSION

# METHODS

method recv() {
  return $self->store->recv($self->term);
}

method send(HashRef $val) {
  return $self->store->send($self->term, $val);
}

method term() {
  return $self->next::method('data');
}

1;
