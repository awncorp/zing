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

has 'on_receive' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_receive($self) {
  $self->can('handle_receive_event')
}

has 'on_register' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_register($self) {
  $self->can('handle_register_event')
}

has 'on_suicide' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_suicide($self) {
  $self->can('handle_suicide_event')
}

has 'process' => (
  is => 'ro',
  isa => 'Process',
  req => 1,
);

# METHODS

method flow() {
  my $step_0 = Zing::Flow->new(
    name => 'on_reset',
    code => fun($step, $loop) { $self->process->log->reset }
  );
  my $step_1 = $step_0->next(Zing::Flow->new(
    name => 'on_register',
    code => fun($step, $loop) { $self->on_register->($self) }
  ));
  my $step_2 = $step_1->next(Zing::Flow->new(
    name => 'on_perform',
    code => fun($step, $loop) { $self->on_perform->($self) }
  ));
  my $step_3 = $step_2->next(Zing::Flow->new(
    name => 'on_receive',
    code => fun($step, $loop) { $self->on_receive->($self) }
  ));
  my $step_4 = $step_3->next(Zing::Flow->new(
    name => 'on_suicide',
    code => fun($step, $loop) { $self->on_suicide->($self) }
  ));

  $step_0
}

method handle_perform_event() {
  my $process = $self->process;

  return if !$process->can('perform');

  return $process->perform();
}

method handle_receive_event() {
  my $process = $self->process;

  return if !$process->can('mailbox');
  return if !$process->can('receive');

  my $data = $process->mailbox->recv or return;

  return $process->receive($data->{from}, $data->{payload});
}

method handle_register_event() {
  my $process = $self->process;

  return if $self->{registered};

  $self->{registered} = Zing::Registry->new->send($process);

  return $self;
}

method handle_suicide_event() {
  my $process = $self->process;

  return if !$process->parent;

  $process->shutdown unless kill 0, $process->parent->node->pid;

  return $self;
}

method signals() {
  my $trapped = {};

  $trapped->{INT} = sub {
    $self->process->shutdown;
  };

  $trapped->{QUIT} = sub {
    $self->process->shutdown;
  };

  $trapped->{TERM} = sub {
    $self->process->shutdown;
  };

  return $trapped;
}

1;
