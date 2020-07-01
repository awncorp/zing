package Zing::Kernel;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Watcher';

use Zing::Channel;
use Zing::Logic::Kernel;
use Zing::Term;

# VERSION

# ATTRIBUTES

has 'journal' => (
  is => 'ro',
  isa => 'Channel',
  new => 1,
);

fun new_journal($self) {
  Zing::Channel->new(name => '$journal')
}

has 'scheme' => (
  is => 'ro',
  isa => 'Scheme',
  req => 1,
);

# BUILDERS

fun new_logic($self) {
  Zing::Logic::Kernel->new(process => $self);
}

# METHODS

method term() {
  return Zing::Term->new($self)->kernel;
}

1;
