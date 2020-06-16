package Zing::Store;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use JSON -convert_blessed_universally;

use Redis;

# VERSION

# ATTRIBUTES

has 'redis' => (
  is => 'ro',
  isa => 'Redis',
  new => 1,
);

fun new_redis($self) {
  state $redis = Redis->new;
}

# METHODS

method drop(Str $key) {
  return $self->redis->del($key);
}

method dump(HashRef $data) {
  return JSON->new->allow_nonref->convert_blessed->encode($data);
}

method keys(Str $key) {
  return [$self->redis->keys($self->term($key, '*'))];
}

method pull(Str $key) {
  my $get = $self->redis->lpop($key);
  return $get ? $self->load($get) : $get;
}

method push(Str $key, HashRef $val) {
  my $set = $self->dump($val);
  return $self->redis->rpush($key, $set);
}

method load(Str $data) {
  return JSON->new->allow_nonref->convert_blessed->decode($data);
}

method recv(Str $key) {
  my $get = $self->redis->get($key);
  return $get ? $self->load($get) : $get;
}

method send(Str $key, HashRef $val) {
  my $set = $self->dump($val);
  return $self->redis->set($key, $set);
}

method size(Str $key) {
  return $self->redis->llen($key);
}

method slot(Str $key, Int $pos) {
  return $self->redis->lindex($key, $pos);
}

method term(Str @keys) {
  return join(':', @keys);
}

method test(Str $key) {
  return int $self->redis->exists($key);
}

1;
