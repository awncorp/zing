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

has 'flow' => (
  is => 'rw',
  isa => 'Flow',
  req => 1,
);

has 'last' => (
  is => 'rw',
  isa => 'Bool',
  def => 0,
);

has 'stop' => (
  is => 'rw',
  isa => 'Bool',
  def => 0,
);

# METHODS

method execute(Any @args) {
  my $step = my $head = $self->flow;

  until ($self->stop) {
    $step->execute($self, @args);
    $step = $step->next || do {
      last if $self->last;
      $head;
    }
  }

  return $self;
}

method exercise(Any @args) {
  my $step = my $head = $self->flow;

  until (!$step) {
    $step->execute($self, @args);
    $step = $step->next;
  }

  return $self;
}

1;
