package Zing::Watcher;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Logic::Watcher;

extends 'Zing::Process';

# VERSION

# ATTRIBUTES

has 'on_scheme' => (
  is => 'ro',
  isa => 'Maybe[CodeRef]',
  opt => 1,
);

# BUILDERS

fun new_logic($self) {
  my $debug = $self->env->debug;
  Zing::Logic::Watcher->new(debug => $debug, process => $self)
}

# METHODS

method scheme(@args) {
  return $self if !$self->on_scheme;

  my $scheme = $self->on_scheme->($self, @args);

  return $scheme;
}

1;
