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

# VERSION

# ATTRIBUTES

has 'on_receipt' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_receipt($self) {
  $self->can('handle_receipt_event')
}

has 'queues' => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  new => 1
);

fun new_queues($self) {
  $self->process->can('queues') ? $self->process->queues : []
}

# METHODS

method flow() {
  my $step_1 = $self->next::method;

  my ($first, $last);

  for my $name (@{$self->queues}) {
    my $step_x = Zing::Flow->new(
      name => "on_receipt_${name}",
      code => fun($step, $loop) { $self->on_receipt->($self, $name) },
    );
    if ($last) {
      $last->next($step_x);
    }
    $last = $step_x;
    $first = $last if !$first;
  }

  $step_1->next($first) if $first;
  $step_1
}

method handle_receipt_event($name) {
  my $process = $self->process;

  warn 'do handle_receipt_event';

  return unless $process->can('receipt');

  my $data = $process->queue($name)->recv or return;

  $process->receipt($name, $data);

  return $self;
}

1;
