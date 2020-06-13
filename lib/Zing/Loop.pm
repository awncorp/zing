package Zing::Loop;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

# VERSION

# ATTRIBUTES

has 'start' => (
  is => 'rw',
  isa => 'Step',
  req => 1,
);

has 'stop' => (
  is => 'rw',
  isa => 'Bool',
  def => 0,
);

# METHODS

method execute(Any @args) {
  my $step = my $head = $self->start;

  until ($self->stop) {
    $step->execute($self, @args);
    $step = $step->next || $head;
  }

  return $self;
}

1;
