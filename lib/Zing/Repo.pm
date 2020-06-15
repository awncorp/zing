package Zing::Repo;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Store;

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
  Zing::Store->new;
}

# METHODS

method ids() {
  return $self->store->keys($self->term);
}

method keys() {
  return [map {my$re = quotemeta $self->term; s/^$re://; $_} @{$self->ids}];
}

method term(Str @keys) {
  return join(':', $self->server->name, $self->name, @keys);
}

method test(Str $key) {
  return $self->store->test($self->term($key));
}

1;
