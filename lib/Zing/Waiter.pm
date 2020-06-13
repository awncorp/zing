package Zing::Waiter;

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
  my $process = $perform->next(Zing::Step->new(
    name => 'on_process',
    code => fun($step, $loop) { $self->on_process },
  ));

  $self->start->append($perform);

  return $self;
}

method on_perform(Any @args) {
  warn 'perform handler';
  $self->perform;
}

method on_process(Any @args) {
  my $data = $self->mailbox->recv or return;

  $self->receive($data->{payload});

  $self->shutdown;

  return $self;
}

1;
