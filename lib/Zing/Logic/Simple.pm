package Zing::Logic::Simple;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Logic';

use Zing::Flow;

# VERSION

# METHODS

method flow() {
  my $step_0 = Zing::Flow->new(
    name => 'on_register',
    code => fun($step, $loop) { $self->on_register->($self) }
  );
  my $step_1 = $step_0->next(Zing::Flow->new(
    name => 'on_perform',
    code => fun($step, $loop) { $self->on_perform->($self) }
  ));
  my $step_2 = $step_1->next(Zing::Flow->new(
    name => 'on_reset',
    code => fun($step, $loop) { $self->process->log->reset }
  ));

  $step_0
}

1;
