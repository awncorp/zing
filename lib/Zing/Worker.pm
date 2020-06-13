package Zing::Worker;

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

has 'queues' => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  new => 1
);

fun new_queues($self) {
  []
}

# BUILD

fun BUILD($self, $args) {
  my ($first, $last, $step);

  for my $name (@{$self->queues}) {
    $step = Zing::Step->new(
      name => "on_process_${name}",
      code => fun($step, $loop) { $self->on_process($name) },
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

method on_process(Str $name) {
  my $data = $self->queue($name)->recv or return;

  $self->perform($data->{payload});

  return $self;
}

1;
