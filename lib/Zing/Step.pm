package Zing::Step;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'next' => (
  is => 'rw',
  isa => 'Step',
  opt => 1,
);

has 'code' => (
  is => 'ro',
  isa => 'CodeRef',
  req => 1,
);

# METHODS

method append(Step $step) {
  $self->bottom->next($step);

  return $self;
}

method bottom() {
  my $step = $self;

  while (my $next = $step->next) {
    $step = $next;
  }

  return $step;
}

method execute(Any @args) {
  return $self->code->($self, @args);
}

method prepend(Step $step) {
  $step->bottom->next($self);

  return $step;
}

1;