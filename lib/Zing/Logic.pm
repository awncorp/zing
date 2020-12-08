package Zing::Logic;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Flow;

# VERSION

# ATTRIBUTES

has 'debug' => (
  is => 'ro',
  isa => 'Bool',
  def => 0,
);

has 'interupt' => (
  is => 'rw',
  isa => 'Interupt',
  opt => 1
);

has 'on_perform' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_perform($self) {
  $self->can('handle_perform_event')
}

has 'on_receive' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_receive($self) {
  $self->can('handle_receive_event')
}

has 'on_register' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_register($self) {
  $self->can('handle_register_event')
}

has 'on_reset' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_reset($self) {
  $self->can('handle_reset_event')
}

has 'on_suicide' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_suicide($self) {
  $self->can('handle_suicide_event')
}

has 'process' => (
  is => 'ro',
  isa => 'Process',
  req => 1,
);

# SHIMS

sub _kill {
  CORE::kill(shift, shift)
}

sub _repr {
  "$_[0]" =~ s/^((?:[\w:]+=*)\w+)\((\w+)\)/($1)/r
}

sub _words {
  (map {ref() ? _repr($_) : m/\s+/ ? qq("$_") : $_} @_)
}

# METHODS

method flow() {
  my $step_0 = Zing::Flow->new(
    name => 'on_register',
    code => fun($step, $loop) { $self->trace('on_register')->($self) }
  );
  my $step_1 = $step_0->next(Zing::Flow->new(
    name => 'on_perform',
    code => fun($step, $loop) { $self->trace('on_perform')->($self) }
  ));
  my $step_2 = $step_1->next(Zing::Flow->new(
    name => 'on_receive',
    code => fun($step, $loop) { $self->trace('on_receive')->($self) }
  ));
  my $step_3 = $step_2->next(Zing::Flow->new(
    name => 'on_reset',
    code => fun($step, $loop) { $self->trace('on_reset')->($self) }
  ));
  my $step_4 = $step_3->next(Zing::Flow->new(
    name => 'on_suicide',
    code => fun($step, $loop) { $self->trace('on_suicide')->($self) }
  ));

  $step_0
}

method note(Any @data) {
  if ($self->debug) {
    $self->process->log->debug(
      join ' ', sprintf('in %s, %s', _words($self, $self->process)), @data
    );
  }
  return $self;
}

method handle_perform_event() {
  my $process = $self->process;

  return $self if !$process->can('perform');

  $process->perform();

  return $self;
}

method handle_receive_event() {
  my $process = $self->process;

  return $self if !$process->can('mailbox');
  return $self if !$process->can('receive');

  my $data = $process->mailbox->recv or return;

  $process->receive($data->{from}, $data->{data});

  return $self;
}

method handle_register_event() {
  my $process = $self->process;

  return $self if $self->{registered};

  $self->{registered} = $process->meta->send($process->metadata);

  return $self;
}

method handle_reset_event() {
  my $process = $self->process;

  if ($process->journal && $process->log->count) {
    $process->journal->send({
      from => $process->name,
      data => {
        logs => $process->log->serialize,
        tag => $process->tag
      }
    });
  }

  $process->log->reset;

  return $self;
}

method handle_suicide_event() {
  my $process = $self->process;

  return $self if !$process->parent;

  # children who don't known their parents kill themeselves :)
  $process->winddown unless $process->ping($process->parent->pid);

  return $self;
}

method signals() {
  my $trapped = {};

  $trapped->{INT} = sub {
    $self->trace('interupt', 'INT');
    $self->process->winddown;
  };

  $trapped->{QUIT} = sub {
    $self->trace('interupt', 'QUIT');
    $self->process->winddown;
  };

  $trapped->{TERM} = sub {
    $self->trace('interupt', 'TERM');
    $self->process->winddown;
  };

  return $trapped;
}

method trace(Str $method, Any @args) {
  my @with = (@args ? (join ', ', 'with', _words(@args)) : ());

  return $self->note(qq(invokes "$method"), @with)->$method(@args);
}

1;
