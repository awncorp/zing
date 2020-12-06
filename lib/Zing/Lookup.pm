package Zing::Lookup;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Domain';

use Digest::MD5;

use Carp ();

# VERSION

# BUILDERS

fun BUILD($self) {
  $self->reset;

  my $savepoint = $self->savepoint;

  if ($savepoint->test) {
    $self->{state} = $savepoint->snapshot;
    $self->{position} = $savepoint->position;
    $self->{metadata} = $savepoint->metadata;
  }

  return $self->apply;
}

# METHODS

method cursor() {
  return $self->env->app->cursor(lookup => $self);
}

method decr(Any @args) {
  Carp::confess(sprintf('Method decr() not supported for %s', ref($self)));
}

around del($key) {
  my $name = $self->hash($key);
  my $item = $self->state->{$name};
  return $self if !$item;
  my $next = $item->{next};
  my $prev = $item->{prev};
  if ($next && $prev) {
    # prev.next = item.next AND next.prev = item.prev
    $self->change('set', $prev, {%{$self->state->{$prev}}, next => $next});
    $self->change('set', $next, {%{$self->state->{$next}}, prev => $prev});
  }
  elsif ($next && !$prev) {
    # next.prev = undef
    $self->metadata->{tail} = $next;
    $self->change('set', $next, { %{$self->state->{$next}}, prev => undef });
  }
  elsif (!$next && $prev) {
    # prev.next = undef
    $self->metadata->{head} = $prev;
    $self->change('set', $prev, { %{$self->state->{$prev}}, next => undef });
  }
  $self->$orig($name);
  $self->env->app->domain(name => $item->{name})->drop;
  return $self;
}

around drop() {
  for my $value (values %{$self->state}) {
    $self->env->app->domain(name => $value->{name})->drop;
  }
  return $self->$orig;
}

method get(Str $key) {
  my $data = $self->apply->state->{$self->hash($key)};
  return undef if !$data;
  return $self->env->app->domain(name => $data->{name});
}

method head() {
  return $self->metadata->{head};
}

method incr(Any @args) {
  Carp::confess(sprintf('Method incr() not supported for %s', ref($self)));
}

method hash(Str @args) {
  return Digest::MD5::md5_hex($self->key(@args));
}

method key(Str @args) {
  return join('.', @args);
}

method pop(Any @args) {
  Carp::confess(sprintf('Method pop() not supported for %s', ref($self)));
}

method push(Any @args) {
  Carp::confess(sprintf('Method push() not supported for %s', ref($self)));
}

method restore(HashRef $data) {
  return $self->{state} = {};
}

method set(Str $key) {
  my $hash = $self->hash($key);
  my $name = join('-', $self->name, $hash);
  my $domain = $self->env->app->domain(name => $name);
  my $prev = $self->apply->head;
  if ($prev && $self->state->{$prev}) {
    $self->change('set', $prev, { %{$self->state->{$prev}}, next => $hash });
  }
  $self->metadata->{head} = $hash;
  $self->metadata->{tail} = $hash if !$self->metadata->{tail};
  $self->change('set', $hash, { name => $name, next => undef, prev => $prev });
  return $domain;
}

method shift(Any @args) {
  Carp::confess(sprintf('Method shift() not supported for %s', ref($self)));
}

method savepoint() {
  return $self->env->app->savepoint(lookup => $self);
}

method snapshot() {
  return {};
}

method tail() {
  return $self->metadata->{tail};
}

method term() {
  return $self->env->app->term($self)->lookup;
}

method unshift(Any @args) {
  Carp::confess(sprintf('Method unshift() not supported for %s', ref($self)));
}

1;
