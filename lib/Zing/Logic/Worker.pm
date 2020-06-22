package Zing::Logic::Worker;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Logic';

use Zing::Flow;
use Zing::Queue;

# VERSION

# ATTRIBUTES

has 'on_handle' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_handle($self) {
  $self->can('handle_handle_event')
}

has 'queues' => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  new => 1
);

fun new_queues($self) {
  $self->process->queues
}

has 'relays' => (
  is => 'ro',
  isa => 'HashRef[Queue]',
  new => 1
);

fun new_relays($self) {
  +{map {$_, Zing::Queue->new(name => $_)} @{$self->queues}}
}

# METHODS

method flow() {
  my $step_0 = $self->next::method;

  my ($step_f, $step_l);

  for my $name (@{$self->queues}) {
    my $label = $name =~ s/\W+/_/gr;
    my $step_x = Zing::Flow->new(
      name => "on_handle_${label}",
      code => fun($step, $loop) { $self->on_handle->($self, $name) },
    );
    $step_l->next($step_x) if $step_l;
    $step_l = $step_x;
    $step_f = $step_l if !$step_f;
  }

  $step_0->append($step_f) if $step_f;
  $step_0
}

method handle_handle_event($name) {
  my $process = $self->process;

  return unless $process->can('handle');

  my $data = $self->relays->{$name}->recv or return;

  $process->handle($name, $data);

  return $data;
}

1;
