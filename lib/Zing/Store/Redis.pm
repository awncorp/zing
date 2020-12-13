package Zing::Store::Redis;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Store';

# VERSION

# ATTRIBUTES

has client => (
  is => 'ro',
  isa => 'InstanceOf["Redis"]',
  new => 1,
);

fun new_client($self) {
  require Redis;
  state $client = Redis->new($self->args($ENV{ZING_REDIS}));
}

# BUILDERS

fun new_encoder($self) {
  require Zing::Encoder::Json; Zing::Encoder::Json->new;
}

# METHODS

method drop(Str $key) {
  return $self->client->del($key);
}

method keys(Str $query) {
  return [map $self->client->keys($query)];
}

method lpull(Str $key) {
  my $get = $self->client->lpop($key);
  return $get ? $self->decode($get) : $get;
}

method lpush(Str $key, HashRef $val) {
  my $set = $self->encode($val);
  return $self->client->lpush($key, $set);
}

method recv(Str $key) {
  my $get = $self->client->get($key);
  return $get ? $self->decode($get) : $get;
}

method rpull(Str $key) {
  my $get = $self->client->rpop($key);
  return $get ? $self->decode($get) : $get;
}

method rpush(Str $key, HashRef $val) {
  my $set = $self->encode($val);
  return $self->client->rpush($key, $set);
}

method send(Str $key, HashRef $val) {
  my $set = $self->encode($val);
  return $self->client->set($key, $set);
}

method size(Str $key) {
  return $self->client->llen($key);
}

method slot(Str $key, Int $pos) {
  my $get = $self->client->lindex($key, $pos);
  return $get ? $self->decode($get) : $get;
}

method test(Str $key) {
  return int $self->client->exists($key);
}

1;
