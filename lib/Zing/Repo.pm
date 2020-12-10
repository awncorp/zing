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

use Zing::Store;
use Zing::Term;

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Name',
  req => 1,
);

has 'store' => (
  is => 'ro',
  isa => 'Store',
  new => 1,
);

fun new_store($self) {
  $self->app->store
}

# METHODS

method drop() {
  return $self->store->drop($self->term);
}

method keys(Str $query) {
  return $self->store->keys($query);
}

method search() {
  $self->app->search(store => $self->store)->using($self);
}

method term() {
  return $self->app->term($self)->repo;
}

method test(Str @keys) {
  return $self->store->test($self->term);
}

1;
