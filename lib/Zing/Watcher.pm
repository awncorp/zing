package Zing::Watcher;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Step;

extends 'Zing::Process';

# VERSION

# ATTRIBUTES

has 'processes' => (
  is => 'ro',
  isa => 'ArrayRef[Process]',
  new => 1
);

fun new_queues($self) {
  {}
}

# BUILD

fun BUILD($self, $args) {
  my ($first, $last, $step);

  for my $process (@{$self->processes}) {
    my $name = (
      $process->name =~ s/\W+/_/gr
    );
    $step = Zing::Step->new(
      name => "on_manage_${name}",
      code => fun($step, $loop) { $self->on_manage($process) },
    );
    if ($last) {
      $last->next($step);
    }
    if (!$first) {
      $first = $last;
    }
    $last = $step;
  }

  $self->start->append($first);

  return $self;
}

method on_manage(Process $process) {
  $self->manage($process);

  return $self;
}

1;
