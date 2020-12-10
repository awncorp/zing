package Zing::Store::Hash;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Store';

# VERSION

our $DATA = {};

# ATTRIBUTES

has data => (
  is => 'ro',
  isa => 'HashRef',
  new => 1,
);

fun new_data($self) {
  $DATA
}

# METHODS

method drop(Str $key) {
  return int(!!delete $self->data->{$key});
}

method encode(HashRef $val) {
  return $self->encoder->encode($data);
}

method keys(Str $key) {
  my $re = join('|', $self->term($key), $self->term($key, '.*'));
  return [grep /$re/, keys %{$self->data}];
}

method decode(Str $data) {
  return $self->encoder->decode($data);
}

method lpull(Str $key) {
  my $get = shift @{$self->data->{$key}} if $self->data->{$key};
  return $get ? $self->decode($get) : $get;
}

method lpush(Str $key, HashRef $val) {
  my $set = $self->encode($val);
  return unshift @{$self->data->{$key}}, $set;
}

method recv(Str $key) {
  my $get = $self->data->{$key};
  return $get ? $self->decode($get) : $get;
}

method rpull(Str $key) {
  my $get = pop @{$self->data->{$key}} if $self->data->{$key};
  return $get ? $self->decode($get) : $get;
}

method rpush(Str $key, HashRef $val) {
  my $set = $self->encode($val);
  return push @{$self->data->{$key}}, $set;
}

method send(Str $key, HashRef $val) {
  my $set = $self->encode($val);
  $self->data->{$key} = $set;
  return 'OK';
}

method size(Str $key) {
  return $self->data->{$key} ? scalar(@{$self->data->{$key}}) : 0;
}

method slot(Str $key, Int $pos) {
  my $get = $self->data->{$key}->[$pos];
  return $get ? $self->decode($get) : $get;
}

method test(Str $key) {
  return int exists $self->data->{$key};
}

1;
