package Zing::Data;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::KeyVal';

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
  mod => 1,
);

fun new_name($self) {
  join(':', map $self->process->node->$_, qw(pid name))
}

has 'process' => (
  is => 'ro',
  isa => 'Process',
  req => 1,
);

# BUILDERS

fun BUILD($self) {
  $self->{name} = $self->new_name;

  return $self;
}

# METHODS

method recv() {
  return $self->store->recv($self->term);
}

method send(HashRef $val) {
  return $self->store->send($self->term, $val);
}

method term() {
  return $self->global($self->name, 'data');
}

1;
