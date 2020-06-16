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
use Zing::Fork;

# VERSION

# ATTRIBUTES

has 'fork' => (
  is => 'ro',
  isa => 'Fork',
  new => 1
);

fun new_fork($self) {
  Zing::Fork->new(parent => $self->process, scheme => $self->scheme)
}

has 'on_launch' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_launch($self) {
  $self->can('handle_launch_event')
}

has 'on_monitor' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_monitor($self) {
  $self->can('handle_monitor_event')
}

has 'on_sanitize' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_sanitize($self) {
  $self->can('handle_sanitize_event')
}

has 'scheme' => (
  is => 'ro',
  isa => 'Scheme',
  new => 1
);

fun new_scheme($self) {
  $self->process->scheme
}

has 'size' => (
  is => 'ro',
  isa => 'Int',
  new => 1
);

fun new_size($self) {
  $self->scheme->[2]
}

# METHODS

method flow() {
  my $step_0 = $self->next::method;

  my $step_1 = Zing::Flow->new(
    name => 'on_launch',
    code => fun($step, $loop) { $self->on_launch->($self) }
  );
  my $step_2 = $step_1->next(Zing::Flow->new(
    name => 'on_monitor',
    code => fun($step, $loop) { $self->on_monitor->($self) }
  ));
  my $step_3 = $step_2->next(Zing::Flow->new(
    name => 'on_sanitize',
    code => fun($step, $loop) { $self->on_sanitize->($self) }
  ));

  $step_0->append($step_1);
  $step_0
}

method handle_launch_event() {
  my $fork = $self->fork;
  my $process = $self->process;

  if ($self->{interupt}) {
    return 0;
  }

  if ($process->loop->stop) {
    return 0;
  }

  my $max_forks = $self->size;
  my $has_forks = keys %{$fork->processes};

  if ($has_forks > $max_forks) {
    return 0; # wtf
  }
  if (my $needs = $max_forks - $has_forks) {
    for (1..$needs) {
      $fork->execute;
    }
  }
  else {
    return 0;
  }
}

method handle_monitor_event() {
  my $fork = $self->fork;

  return $fork->monitor;
}

method handle_sanitize_event() {
  my $fork = $self->fork;

  return $fork->sanitize;
}

method signals() {
  my $trapped = {};
  my $fork = $self->fork;

  $trapped->{INT} = sub {
    $self->{interupt} = 'int';
    $fork->terminate($self->{interupt});
    do {0} while ($fork->sanitize); # reaping children
    $self->process->shutdown;
  };

  $trapped->{QUIT} = sub {
    $self->{interupt} = 'quit';
    $fork->terminate($self->{interupt});
    do {0} while ($fork->sanitize); # reaping children
    $self->process->shutdown;
  };

  $trapped->{TERM} = sub {
    $self->{interupt} = 'term';
    $fork->terminate($self->{interupt});
    do {0} while ($fork->sanitize); # reaping children
    $self->process->shutdown;
  };

  return $trapped;
}

1;
