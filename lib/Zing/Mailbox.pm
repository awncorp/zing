package Zing::Mailbox;

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
  return $self->store->pull($self->term);
}

method send(HashRef $val) {
  return $self->store->push($self->term, $val);
}

method term(Str @keys) {
  return join(':', $self->name, 'pubsub', 'mailbox');
}

1;
