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
  def => '$dropbox',
  mod => 1,
);

# BUILDERS

method BUILD($args) {
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
