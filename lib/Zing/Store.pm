package Zing::Store;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use JSON -convert_blessed_universally;

# VERSION

# ATTRIBUTES

has 'redis' => (
  is => 'ro',
  isa => 'Redis',
  new => 1,
);

fun new_redis($self) {
  require Redis;
  state $redis = Redis->new(
    # e.g. ZING_REDIS='server=127.0.0.1:9999,debug=0'
    map +($$_[0], $#{$$_[1]} ? $$_[1] : $$_[1][0]),
    map [$$_[0], [split /\|/, $$_[1]]],
    map [split /=/], split /,\s*/,
    $ENV{ZING_REDIS} || ''
  );
}

# METHODS

method drop(Str $key) {
  return $self->redis->del($key);
}

method dump(HashRef $data) {
  return JSON->new->allow_nonref->convert_blessed->encode($data);
}

method keys(Str @keys) {
  return [map $self->redis->keys($self->term(@$_)), [@keys], [@keys, '*']];
}

method pop(Str $key) {
  my $get = $self->redis->rpop($key);
  return $get ? $self->load($get) : $get;
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
  my $get = $self->redis->lindex($key, $pos);
  return $get ? $self->load($get) : $get;
}

method term(Str @keys) {
  return join(':', @keys);
}

method test(Str $key) {
  return int $self->redis->exists($key);
}

1;
