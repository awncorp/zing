package Zing::Logic::Watcher;

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

has 'on_manage' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_manage($self) {
  $self->can('handle_manage_event')
}

has 'processes' => (
  is => 'ro',
  isa => 'ArrayRef[Process]',
  new => 1
);

fun new_processes($self) {
  $self->process->can('processes') ? $self->process->processes : []
}

# METHODS

method flow() {
  my $step_1 = $self->next::method;

  my ($first, $last);

  for my $process (@{$self->processes}) {
    my $name = (
      $process->name =~ s/\W+/_/gr
    );
    my $step_x = Zing::Flow->new(
      name => "on_manage_${name}",
      code => fun($step, $loop) { $self->on_manage->($self, $process) },
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

method handle_manage_event($process) {
  my $process = $self->process;

  warn 'do handle_manage_event';

  return unless $process->can('manage');

  my $data = $process->mailbox->recv or return;

  $process->manage($process);

  return $self;
}

method handle_process_event() {
  my $process = $self->process;

  warn 'do handle_process_event';

  return unless $process->can('receive');

  my $data = $process->mailbox->recv or return;

  $process->receive($data->{payload});

  $process->shutdown;

  return $self;
}

1;
