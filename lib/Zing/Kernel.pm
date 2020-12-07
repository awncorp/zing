package Zing::Kernel;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Watcher';

use Zing::Logic::Kernel;

# VERSION

# ATTRIBUTES

has 'journal' => (
  is => 'ro',
  isa => 'Channel',
  new => 1,
);

fun new_journal($self) {
  $self->app->journal
}

has 'scheme' => (
  is => 'ro',
  isa => 'Scheme',
  req => 1,
);

# BUILDERS

fun new_logic($self) {
  my $debug = $self->env->debug;
  Zing::Logic::Kernel->new(debug => $debug, process => $self)
}

# METHODS

method term() {
  return $self->app->term($self)->kernel;
}

1;
