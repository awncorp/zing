package Zing::Flow;

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
  isa => 'Flow',
  opt => 1,
);

has 'code' => (
  is => 'ro',
  isa => 'CodeRef',
  req => 1,
);

# METHODS

method append(Flow $flow) {
  $self->bottom->next($flow);

  return $self;
}

method bottom() {
  my $flow = $self;

  while (my $next = $flow->next) {
    $flow = $next;
  }

  return $flow;
}

method execute(Any @args) {
  return $self->code->($self, @args);
}

method prepend(Flow $flow) {
  $flow->bottom->next($self);

  return $flow;
}

1;