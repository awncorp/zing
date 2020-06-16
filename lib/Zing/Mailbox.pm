package Zing::Mailbox;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::PubSub';

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
  return $self->store->pull($self->term);
}

method send(Message $val) {
  return $self->store->push($self->term, $val->serialize);
}

method size() {
  return $self->store->size($self->term);
}

method term() {
  return $self->next::method('mailbox');
}

1;
