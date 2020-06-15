package Zing::Logic;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Flow;
use Zing::Registry;

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

has 'on_register' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_register($self) {
  $self->can('handle_register_event')
}

has 'process' => (
  is => 'ro',
  isa => 'Process',
  req => 1,
);

# METHODS

method flow() {
  my $step_1 = Zing::Flow->new(
    name => 'on_register',
    code => fun($step, $loop) { $self->on_register->($self) }
  );
  my $step_2 = $step_1->next(Zing::Flow->new(
    name => 'on_perform',
    code => fun($step, $loop) { $self->on_perform->($self) }
  ));

  $step_1
}

method handle_perform_event() {
  my $process = $self->process;

  $process->perform($self) if $process->can('perform');

  return $self;
}

method handle_register_event() {
  my $process = $self->process;

  return if $self->{registered};

  $self->{registered} = Zing::Registry->new->send($process);

  return $self;
}

1;
