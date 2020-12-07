package Zing::Repo;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

extends 'Zing::Entity';

use Zing::Server;
use Zing::Store;
use Zing::Term;

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'server' => (
  is => 'ro',
  isa => 'Server',
  new => 1,
);

fun new_server($self) {
  Zing::Server->new
}

has 'store' => (
  is => 'ro',
  isa => 'Store',
  new => 1,
);

fun new_store($self) {
  $self->app->store
}

has 'target' => (
  is => 'ro',
  isa => 'Enum[qw(global local)]',
  new => 1,
);

fun new_target($self) {
  $self->env->target || 'local'
}

# METHODS

method drop(Str @keys) {
  return $self->store->drop($self->term(@keys));
}

method keys() {
  return $self->store->keys($self->term);
}

method term(Str @keys) {
  return $self->app->term($self, @keys)->repo;
}

method test(Str @keys) {
  return $self->store->test($self->term(@keys));
}

1;
