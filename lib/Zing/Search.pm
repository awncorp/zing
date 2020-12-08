package Zing::Search;

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

has 'handle' => (
  is => 'rw',
  isa => 'Str',
  def => '*',
);

has 'symbol' => (
  is => 'rw',
  isa => 'Str',
  def => '*',
);

has 'bucket' => (
  is => 'rw',
  isa => 'Str',
  def => '*',
);

has 'system' => (
  is => 'rw',
  isa => 'Name',
  def => 'zing',
);

has 'target' => (
  is => 'rw',
  isa => 'Str',
  def => '*',
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

method for(Str $type) {
  return $self->where(
    bucket => '*',
    symbol => lc($type),
    handle => $self->env->handle || '*',
    target => $self->env->target || '*',
  );
}

method objects() {
  my $result = [];

  $self->process(fun($term) {
    push @$result, $self->app->term($term)->object;
  });

  return $result;
}

method process(CodeRef $callback) {
  for my $term (@{$self->results}) {
    $callback->($term);
  }

  return $self;
}

method query() {
  my $system = $self->system || '*';
  my $handle = $self->handle || '*';
  my $target = $self->target || '*';
  my $symbol = $self->symbol || '*';
  my $bucket = $self->bucket || '*';

  return lc join ':', $system, $handle, $target, $symbol, $bucket;
}

method results() {
  return $self->store->keys($self->query);
}

method using(Repo $repo) {
  my $term = $self->app->term($repo);

  return $self->where(
    bucket => $term->bucket,
    handle => $term->handle,
    symbol => $term->symbol,
    system => $term->system,
    target => $term->target,
  );
}

method where(Str %args) {
  $self->$_($args{$_}) for keys %args;

  return $self;
}

1;
