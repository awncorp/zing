package Zing::Repo;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

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
  Data::Object::Space->new($ENV{ZING_STORE} || 'Zing::Redis')->build
}

has 'target' => (
  is => 'ro',
  isa => 'Enum[qw(global local)]',
  new => 1,
);

fun new_target($self) {
  $ENV{ZING_TARGET} || 'local'
}

# METHODS

method drop(Str @keys) {
  return $self->store->drop($self->term(@keys));
}

method ids() {
  return $self->store->keys($self->term);
}

method keys() {
  return [map {my $re = quotemeta $self->term; s/^$re://r} @{$self->ids}];
}

method term(Str @keys) {
  return Zing::Term->new($self, @keys)->repo;
}

method test(Str @keys) {
  return $self->store->test($self->term(@keys));
}

1;
