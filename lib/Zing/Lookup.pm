package Zing::Lookup;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Domain';

use Digest::SHA ();

# VERSION

# BUILDERS

fun BUILD($self) {
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
  return $self->app->cursor(lookup => $self);
}

method decr(Any @args) {
  $self->throw(error_not_supported($self, 'decr'));
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
    $self->change('set', $next, {%{$self->state->{$next}}, prev => undef});
  }
  elsif (!$next && $prev) {
    # prev.next = undef
    $self->metadata->{head} = $prev;
    $self->change('set', $prev, {%{$self->state->{$prev}}, next => undef});
  }
  $self->$orig($name);
  $self->app->domain(name => $item->{name})->drop;
  return $self;
}

around drop() {
  if (my $savepoint = $self->savepoint) {
    $savepoint->drop if $savepoint->test;
  }
  for my $value (values %{$self->state}) {
    $self->app->domain(name => $value->{name})->drop;
  }
  return $self->$orig;
}

method get(Str $key) {
  my $data = $self->apply->state->{$self->hash($key)};
  return undef if !$data;
  return $self->app->domain(name => $data->{name});
}

method head() {
  return $self->metadata->{head};
}

method incr(Any @args) {
  $self->throw(error_not_supported($self, 'incr'));
}

method hash(Str $key) {
  return Digest::SHA::sha1_hex($key);
}

method pop(Any @args) {
  $self->throw(error_not_supported($self, 'pop'));
}

method push(Any @args) {
  $self->throw(error_not_supported($self, 'push'));
}

method restore(HashRef $data) {
  return $self->{state} = {};
}

method set(Str $key) {
  my $hash = $self->hash($key);
  my $name = $key;
  my $domain = $self->app->domain(name => $name);
  my $prev = $self->apply->head;
  if ($prev && $self->state->{$prev}) {
    $self->change('set', $prev, {%{$self->state->{$prev}}, next => $hash});
  }
  $self->metadata->{head} = $hash;
  $self->metadata->{tail} = $hash if !$self->metadata->{tail};
  $self->change('set', $hash, {name => $name, next => undef, prev => $prev});
  return $domain;
}

method shift(Any @args) {
  $self->throw(error_not_supported($self, 'shift'));
}

method savepoint() {
  return $self->app->savepoint(lookup => $self);
}

method snapshot() {
  return {};
}

method tail() {
  return $self->metadata->{tail};
}

method term() {
  return $self->app->term($self)->lookup;
}

method unshift(Any @args) {
  $self->throw(error_not_supported($self, 'unshift'));
}

# ERRORS

fun error_not_supported(Object $object, Str $method) {
  code => 'error_not_implemented',
  message => "@{[ref($object)]} method \"$method\" not supported",
}

1;
