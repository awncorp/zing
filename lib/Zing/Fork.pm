package Zing::Fork;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

use Carp ();
use POSIX ();

use Config;

# VERSION

# ATTRIBUTES

has 'class' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'args' => (
  is => 'ro',
  isa => 'ArrayRef',
  def => sub{[]},
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
  Data::Object::Space->new($self->class)
}

# METHODS

method execute() {
  my $pid;
  my $process;

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
      @{$self->args}, node => Zing::Node->new(pid => $pid)
    );
    return $process;
  }
  # child
  else {
    $pid = $$;
    $process = $self->space->build(
      @{$self->args}, node => Zing::Node->new(pid => $pid)
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

  return $self;
}

method terminate($signal = 'HUP') {
  my $result = {};

  for my $pid (sort keys %{$self->processes}) {
    $result->{$pid} = kill $signal, $pid;
  }

  return $result;
}

1;
