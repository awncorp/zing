package Zing::Mailbox;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::PubSub';

with 'Zing::Context';

use Zing::Term;

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Str',
  init_arg => undef,
  new => 1,
);

fun new_name($self) {
  $self->process->name
}

has 'process' => (
  is => 'ro',
  isa => 'Process',
  req => 1,
);

# BUILDERS

fun new_target($self) {
  $self->env->target || 'global'
}

# METHODS

method recv() {
  return $self->store->lpull($self->term);
}

method message(HashRef $val) {
  return { data => $val, from => $self->term };
}

method reply(HashRef $bag, HashRef $val) {
  return $self->send($bag->{from}, $val);
}

method send(Str $key, HashRef $val) {
  return $self->store->rpush($self->term($key), $self->message($val));
}

method size() {
  return $self->store->size($self->term);
}

method term(Maybe[Str] $name) {
  return $self->env->app->term($name || $self)->mailbox;
}

1;
