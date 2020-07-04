package Zing::Redis;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Store';

use JSON -convert_blessed_universally;

# VERSION

# ATTRIBUTES

has 'client' => (
  is => 'ro',
  isa => 'Redis',
  new => 1,
);

fun new_client($self) {
  require Redis;
  # e.g. ZING_REDIS='server=127.0.0.1:9999,debug=0'
  state $client = Redis->new($self->args($ENV{ZING_REDIS}));
}

# METHODS

method drop(Str $key) {
  return $self->client->del($key);
}

method dump(HashRef $data) {
  return JSON->new->allow_nonref->convert_blessed->encode($data);
}

method keys(Str @keys) {
  return [map $self->client->keys($self->term(@$_)), [@keys], [@keys, '*']];
}

method pop(Str $key) {
  my $get = $self->client->rpop($key);
  return $get ? $self->load($get) : $get;
}

method pull(Str $key) {
  my $get = $self->client->lpop($key);
  return $get ? $self->load($get) : $get;
}

method push(Str $key, HashRef $val) {
  my $set = $self->dump($val);
  return $self->client->rpush($key, $set);
}

method load(Str $data) {
  return JSON->new->allow_nonref->convert_blessed->decode($data);
}

method recv(Str $key) {
  my $get = $self->client->get($key);
  return $get ? $self->load($get) : $get;
}

method send(Str $key, HashRef $val) {
  my $set = $self->dump($val);
  return $self->client->set($key, $set);
}

method size(Str $key) {
  return $self->client->llen($key);
}

method slot(Str $key, Int $pos) {
  my $get = $self->client->lindex($key, $pos);
  return $get ? $self->load($get) : $get;
}

method test(Str $key) {
  return int $self->client->exists($key);
}

1;
