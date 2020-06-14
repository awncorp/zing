package Zing::Logic::Waiter;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Logic';

use Zing::Flow;

# VERSION

# ATTRIBUTES

has 'on_process' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_process($self) {
  $self->can('handle_process_event')
}

# METHODS

method flow() {
  my $step_1 = $self->next::method;
  my $step_2 = $step_1->next(Zing::Flow->new(
    name => 'on_process',
    code => fun($step, $loop, $self) { $self->on_process->($self) },
  ));

  $step_1
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
