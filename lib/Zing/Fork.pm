package Zing::Fork;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

use POSIX ();

use Config;

# VERSION

# ATTRIBUTES

has 'scheme' => (
  is => 'ro',
  isa => 'Scheme',
  req => 1,
);

has 'parent' => (
  is => 'rw',
  isa => 'Process',
  req => 1,
);

has 'processes' => (
  is => 'rw',
  isa => 'HashRef[Process]',
  def => sub{{}},
);

has 'space' => (
  is => 'ro',
  isa => 'Space',
  new => 1
);

fun new_space($self) {
  Data::Object::Space->new($self->scheme->[0])
}

# SHIMS

sub _waitpid {
  CORE::waitpid(shift, POSIX::WNOHANG)
}

# METHODS

method execute() {
  my $pid;
  my $process;
  my $sid = $$;

  if ($Config{d_pseudofork}) {
    Carp::confess "Error on fork: fork emulation not supported";
  }

  if(!defined($pid = fork)) {
    Carp::confess "Error on fork: $!";
  }

  # parent
  if ($pid) {
    $process = $self->space->load->new(
      @{$self->scheme->[1]},
      pid => $pid,
      parent => $self->parent,
    );
    return $self->processes->{$pid} = $process;
  }
  # child
  else {
    $pid = $$;
    $process = $self->space->reload->new(
      @{$self->scheme->[1]},
      pid => $pid,
      parent => $self->parent,

    );
    $process->execute;
  }

  POSIX::_exit(0);
}

method monitor() {
  my $result = {};

  for my $pid (sort keys %{$self->processes}) {
    $result->{$pid} = _waitpid $pid;
  }

  return $result;
}

method sanitize() {
  my $result = $self->monitor;

  for my $pid (sort keys %{$result}) {
    if ($result->{$pid} == $pid || $result->{$pid} == -1) {
      delete $self->processes->{$pid};
    }
  }

  return scalar(keys %{$self->processes});
}

method terminate(Str $signal = 'kill') {
  my $result = {};

  for my $pid (sort keys %{$self->processes}) {
    $result->{$pid} = $self->processes->{$pid}->signal($pid, $signal);
  }

  return $result;
}

1;
