package Zing::Savepoint;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Entity';

# VERSION

# ATTRIBUTES

has 'lookup' => (
  is => 'ro',
  isa => 'Lookup',
  req => 1,
);

# METHODS

method cached() {
  return $self->{cached} ||= $self->recv;
}

method capture() {
  my $properties = {};

  my $lookup = $self->lookup->apply;

  $properties->{position} = $lookup->{position};
  $properties->{metadata} = $lookup->metadata;
  $properties->{snapshot} = $lookup->state;

  return $properties;
}

method drop() {
  return $self->repo->drop;
}

method position() {
  my $capture = $self->cached or return undef;
  return $capture->{position};
}

method metadata() {
  my $capture = $self->cached or return undef;
  return $capture->{metadata};
}

method name() {
  return join('$', $self->lookup->name, 'savepoint');
}

method repo() {
  return $self->app->keyval(name => $self->name);
}

method recv() {
  return $self->repo->recv;
}

method send() {
  my $capture = $self->capture;
  $self->repo->send($capture);
  return $self->{cached} = $capture;
}

method snapshot() {
  my $capture = $self->cached or return undef;
  return $capture->{snapshot};
}

method test() {
  return $self->repo->test;
}

1;
