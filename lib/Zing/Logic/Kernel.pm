package Zing::Logic::Kernel;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Logic::Watcher';

# VERSION

# METHODS

method flow() {
  my $step_0 = $self->next::method;

  my $step_1 = Zing::Flow->new(
    name => 'on_purge',
    code => fun($step, $loop) { $self->trace('handle_purge_event') }
  );

  $step_0->append($step_1);
  $step_0
}

method handle_purge_event() {
  my $process = $self->process;

  return $self if !$process->env->debug;
  return $self if !$process->can('journal');

  # check every minute (60 secs) not every tick
  if ($self->{purge_at}) {
    return $self if $self->{purge_at} > time;
  }
  else {
    $self->{purge_at} = time+60;
    return $self;
  }

  $process->journal->drop if $process->journal->size > 10_000;

  $self->{purge_at} = time+60;

  return $self;
}

1;
