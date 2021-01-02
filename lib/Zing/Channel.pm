package Zing::Channel;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::PubSub';

# VERSION

# BUILDERS

fun BUILD($self) {
  $self->{position} = $self->size if !$self->isa('Zing::Table');

  return $self;
}

# METHODS

method recv() {
  $self->{position}++ if (
    my $data = $self->store->slot($self->term, int($self->{position}))
  );
  return $data;
}

method renew() {
  return $self->reset if $self->{position} > $self->size;
  return 0;
}

method reset() {
  return !($self->{position} = 0);
}

method send(HashRef $value) {
  return $self->store->rpush($self->term, $value);
}

method size() {
  return $self->store->size($self->term);
}

method term() {
  return $self->app->term($self)->channel;
}

1;
