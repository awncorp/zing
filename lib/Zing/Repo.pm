package Zing::Repo;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Server;
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

has 'target' => (
  is => 'ro',
  isa => 'Enum[qw(global local)]',
  new => 1,
);

fun new_target($self) {
  'local'
}

# METHODS

state $ns = $ENV{ZING_NS} || 'main';

method drop(Str @keys) {
  return $self->store->drop($self->term(@keys));
}

method global (Str @keys) {
  join ':', map {s/[^a-zA-Z0-9\$\.]/-/g; lc} split /:/,
  join ':', 'zing', $ns, @keys
}

method ids() {
  return $self->store->keys($self->term);
}

method keys() {
  return [map {my $re = quotemeta $self->term; s/^$re://r} @{$self->ids}];
}

method local(Str @keys) {
  join ':', map {s/[^a-zA-Z0-9\$\.]/-/g; lc} split /:/,
  join ':', 'zing', $ns, $self->server->name, @keys
}

method term(Str @keys) {
  return $self->${\"@{[$self->target]}"}($self->name, @keys);
}

method test(Str @keys) {
  return $self->store->test($self->term(@keys));
}

1;
