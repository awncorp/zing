package Zing::Table;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Channel';

# VERSION

# ATTRIBUTES

has 'type' => (
  is => 'rw',
  isa => 'TableType',
  def => 'domain',
);

has 'position' => (
  is => 'rw',
  isa => 'Maybe[Int]',
  def => undef,
);

# METHODS

method count() {
  return int $self->size;
}

method drop() {
  $self->reset;
  while (my $domain = $self->next) {
    $domain->drop;
  }
  return $self->store->drop($self->term);
}

method fetch(Int $size = 1) {
  my $results = [];

  for (1..$size) {
    if (my $domain = $self->next) {
      push @$results, $domain;
    }
  }

  return $results;
}

method first() {
  return $self->head;
}

method get(Str $key) {
  my $type = $self->type;
  return $self->app->$type(name => $key);
}

method head() {
  my $position = 0;

  if (my $data = $self->store->slot($self->term, $position)) {
    return $self->app->term($data->{term})->object;
  }
  else {
    return undef;
  }
}

method index(Int $position) {
  if (my $data = $self->store->slot($self->term, $position)) {
    return $self->app->term($data->{term})->object;
  }
  else {
    return undef;
  }
}

method last() {
  return $self->tail;
}

method next() {
  my $position = $self->position;

  if (!defined $position) {
    $position = 0;
  }
  else {
    $position++;
  }
  if (my $data = $self->store->slot($self->term, $position)) {
    $self->position($position);
    return $self->app->term($data->{term})->object;
  }
  else {
    $self->position($position) if $position == $self->size;
    return undef;
  }
}

method prev() {
  my $position = $self->position;

  if (!defined $position) {
    return undef;
  }
  elsif ($position == 0) {
    $self->position(undef);
    return undef;
  }
  else {
    $position--;
  }
  if (my $data = $self->store->slot($self->term, $position)) {
    $self->position($position);
    return $self->app->term($data->{term})->object;
  }
  else {
    return undef;
  }
}

around recv() {
  if (my $data = $self->$orig) {
    return $self->app->term($data->{term})->object;
  }
  else {
    return undef;
  }
}

method renew() {
  return $self->reset if (($self->{position} || 0) + 1) > $self->size;
  return 0;
}

method reset() {
  return !($self->{position} = undef);
}

method set(Str $key) {
  my $type = $self->type;
  my $repo = $self->app->$type(name => $key);
  $self->send({term => $repo->term});
  return $repo;
}

method tail() {
  my $size = $self->size;
  my $position = $size ? ($size - 1) : 0;

  if (my $data = $self->store->slot($self->term, $position)) {
    return $self->app->term($data->{term})->object;
  }
  else {
    return undef;
  }
}

method term() {
  return $self->app->term($self)->table;
}

1;
