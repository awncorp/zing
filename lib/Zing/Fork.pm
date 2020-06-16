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
  isa => 'Tuple[Str, ArrayRef, Int]',
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

# METHODS

method execute() {
  my $pid;
  my $process;
  my $sid = $$;

  $self->space->load;

  if ($Config{d_pseudofork}) {
    die "Error on fork: fork emulation not supported";
  }

  if(!defined($pid = fork)) {
    die "Error on fork: $!";
  }

  # parent
  if ($pid) {
    $process = $self->processes->{$pid} = $self->space->build(
      @{$self->scheme->[1]},
      node => Zing::Node->new(pid => $pid),
      parent => $self->parent,
    );
    return $process;
  }
  # child
  else {
    $pid = $$;
    $process = $self->space->build(
      @{$self->scheme->[1]},
      node => Zing::Node->new(pid => $pid),
      parent => $self->parent,

    );
    $process->execute;
  }

  POSIX::_exit(0);
}

method monitor() {
  my $result = {};

  for my $pid (sort keys %{$self->processes}) {
    $result->{$pid} = waitpid $pid, POSIX::WNOHANG;
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

method terminate($signal = 'KILL') {
  my $result = {};

  for my $pid (sort keys %{$self->processes}) {
    $result->{$pid} = kill uc($signal), $pid;
  }

  return $result;
}

1;
