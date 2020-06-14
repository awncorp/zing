package Zing::Logic;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Flow;

# VERSION

# ATTRIBUTES

has 'on_perform' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_perform($self) {
  $self->can('handle_perform_event')
}

has 'process' => (
  is => 'ro',
  isa => 'Process',
  req => 1,
);

# METHODS

method flow() {
  my $step_1 = Zing::Flow->new(
    name => 'on_perform',
    code => fun($step, $loop) { $self->on_perform->($self) }
  );

  $step_1
}

method handle_perform_event() {
  my $process = $self->process;

  warn 'do handle_perform_event';

  $process->perform($self) if $process->can('perform');

  return $self;
}

1;
