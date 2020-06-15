package Zing::Message;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

# VERSION

# ATTRIBUTES

has 'from' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'created' => (
  is => 'ro',
  isa => 'Int',
  new => 1,
);

fun new_created($self) {
  time
}

has 'retried' => (
  is => 'ro',
  isa => 'Int',
  def => 0,
);

has 'updated' => (
  is => 'ro',
  isa => 'Int',
  new => 1,
);

fun new_updated($self) {
  time
}

has 'payload' => (
  is => 'ro',
  isa => 'HashRef',
  new => 1,
);

fun new_payload($self) {
  {}
}

# BUILD

fun BUILD($self, $args) {
  $self->created;
  $self->updated;
  $self->payload;
}

# METHODS

method serialize() {
  my $data = {};

  $data->{$_} = $self->$_ for qw(
    from
    created
    retried
    updated
    payload
  );

  return $data;
}

1;
