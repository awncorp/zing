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
  $self->{cursor} = $self->size;

  return $self;
}

# METHODS

method recv() {
  $self->{cursor}++ if (
    my $data = $self->store->slot($self->term, int($self->{cursor}))
  );
  return $data;
}

method renew() {
  return !($self->{cursor} = 0) if $self->{cursor} > $self->size;
  return 0;
}

method reset() {
  return !($self->{cursor} = 0);
}

method send(HashRef $val) {
  return $self->store->push($self->term, $val);
}

method size() {
  return $self->store->size($self->term);
}

method term() {
  return $self->next::method('channel');
}

1;
