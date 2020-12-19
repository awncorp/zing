package Zing::Mailbox;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::PubSub';

# VERSION

# METHODS

method recv() {
  return $self->store->lpull($self->term);
}

method message(HashRef $value) {
  return { data => $value, from => $self->term };
}

method reply(HashRef $msg, HashRef $value) {
  return $self->send($msg->{from}, $value);
}

method send(Str $key, HashRef $value) {
  return $self->store->rpush($self->term($key), $self->message($value));
}

method size() {
  return $self->store->size($self->term);
}

method term(Maybe[Str] $name) {
  return $self->app->term($name || $self)->mailbox;
}

1;
