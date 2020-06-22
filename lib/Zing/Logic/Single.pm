package Zing::Logic::Single;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;

extends 'Zing::Logic';

# VERSION

# METHODS

method flow() {
  my $step_0 = Zing::Flow->new(
    name => 'on_reset',
    code => fun($step, $loop) { $self->on_reset->($self) }
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
    name => 'on_suicide',
    code => fun($step, $loop) { $self->on_suicide->($self) }
  ));

  $step_0
}

method handle_perform_event() {
  my $process = $self->process;

  my $result = $self->next::method;

  $process->winddown;

  return $result;
}

1;
