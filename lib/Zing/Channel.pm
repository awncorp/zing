package Zing::Channel;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::PubSub';

use Zing::Term;

# VERSION

# BUILDERS

fun BUILD($self) {
  $self->{position} = $self->size;

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

method send(HashRef $val) {
  return $self->store->rpush($self->term, $val);
}

method size() {
  return $self->store->size($self->term);
}

method term() {
  return Zing::Term->new($self)->channel;
}

1;
