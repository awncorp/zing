package Zing::Single;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

use Zing::Step;

extends 'Zing::Process';

# VERSION

# BUILD

fun BUILD($self, $args) {
  my $perform = Zing::Step->new(
    name => 'on_perform',
    code => fun($step, $loop) { $self->on_perform }
  );
  my $final = $perform->next(Zing::Step->new(
    name => 'on_final',
    code => fun($step, $loop) { $loop->stop(1) },
  ));

  $self->start->append($perform);

  return $self;
}

method on_perform(Any @args) {
  warn 'perform handler';
  $self->perform;
}

1;
