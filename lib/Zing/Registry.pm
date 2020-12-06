package Zing::Registry;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::KeyVal';

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Str',
  def => '$default',
  mod => 1,
);

# METHODS

method clean() {
  for my $term (@{$self->keys}) {
    if (my $data = $self->store->recv($term)) {
      if (my $pid = $data->{process}) {
        $self->store->drop($term) if !kill 0, $pid;
      }
    }
  }
  return $self;
}

method drop(Process $proc) {
  return $self->store->drop($self->term($proc->name));
}

method recv(Process $proc) {
  return $self->store->recv($self->term($proc->name));
}

method send(Process $proc) {
  return $self->store->send($self->term($proc->name), $proc->metadata);
}

method term(Str @keys) {
  return $self->env->app->term($self, @keys)->registry;
}

method terms() {
  return $self->store->keys((split /:/, $self->term)[0,1,2,3]);
}

1;
