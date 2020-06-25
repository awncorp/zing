package Zing::Dropbox;

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
  init_arg => undef,
  new => 1,
  mod => 1,
);

fun new_name($self) {
  '$dropbox'
}

# BUILDERS

fun BUILD($self) {
  $self->{name} = '$dropbox';

  return $self;
}

# METHODS

method poll(Str $name, Int $secs) {
  my $data;
  my $time = time + $secs;

  until ($data = $self->recv($name)) {
    last if time >= $time;
  }

  $self->drop($name);

  return $data;
}

1;
