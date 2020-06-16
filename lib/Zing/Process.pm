package Zing::Process;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

with 'Zing::Role::Messageability';
with 'Zing::Role::Queueability';

use Config;
use FlightRecorder;
use POSIX;

use Zing::Data;
use Zing::Logic;
use Zing::Loop;
use Zing::Mailbox;
use Zing::Node;
use Zing::Registry;

# VERSION

# ATTRIBUTES

has 'cleanup' => (
  is => 'ro',
  isa => 'Bool',
  def => 1,
);

has 'data' => (
  is => 'ro',
  isa => 'Data',
  new => 1,
);

fun new_data($self) {
  Zing::Data->new(process => $self)
}

has 'log' => (
  is => 'ro',
  isa => 'Logger',
  hnd => [qw(info debug warn fatal)],
  new => 1,
);

fun new_log($self) {
  FlightRecorder->new(auto => undef, level => 'info')
}

has 'logic' => (
  is => 'ro',
  isa => 'Logic',
  new => 1,
);

fun new_logic($self) {
  Zing::Logic->new(process => $self);
}

has 'loop' => (
  is => 'ro',
  isa => 'Loop',
  new => 1,
);

fun new_loop($self) {
  Zing::Loop->new(flow => $self->logic->flow)
}

has 'mailbox' => (
  is => 'ro',
  isa => 'Mailbox',
  new => 1,
);

fun new_mailbox($self) {
  Zing::Mailbox->new(process => $self)
}

has 'name' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_name($self) {
  $self->node->identifier
}

has 'node' => (
  is => 'ro',
  isa => 'Node',
  new => 1,
);

fun new_node($self) {
  Zing::Node->new
}

has 'parent' => (
  is => 'ro',
  isa => 'Maybe[Process]',
  opt => 1,
);

has 'registry' => (
  is => 'ro',
  isa => 'Server',
  new => 1,
);

fun new_registry($self) {
  Zing::Registry->new
}

has 'server' => (
  is => 'ro',
  isa => 'Server',
  new => 1,
);

fun new_server($self) {
  Zing::Server->new
}

has 'signals' => (
  is => 'ro',
  isa => 'HashRef[Str|CodeRef]',
  new => 1,
);

fun new_signals($self) {
  $self->logic->signals
}

has 'started' => (
  is => 'rw',
  isa => 'Int',
  def => 0,
);

has 'stopped' => (
  is => 'rw',
  isa => 'Int',
  def => 0,
);

# METHODS

method destroy() {
  return $self if !$self->cleanup;

  $self->data->drop;
  $self->mailbox->drop;
  $self->metadata->drop;

  $self->registry->drop($self);

  return $self;
}

method exercise() {
  $self->started(time);

  local $SIG{CHLD};
  local $SIG{HUP};
  local $SIG{INT};
  local $SIG{QUIT};
  local $SIG{TERM};
  local $SIG{USR1};
  local $SIG{USR2};

  my $signals = $self->signals;

  $SIG{$_} = $self->signals->{$_} for keys %{$signals};

  $self->loop->exercise($self);

  $self->destroy;

  $self->stopped(time);

  return $self;
}

method execute() {
  $self->started(time);

  local $SIG{CHLD};
  local $SIG{HUP};
  local $SIG{INT};
  local $SIG{QUIT};
  local $SIG{TERM};
  local $SIG{USR1};
  local $SIG{USR2};

  my $signals = $self->signals;

  $SIG{$_} = $self->signals->{$_} for keys %{$signals};

  $self->loop->execute($self);

  $self->destroy;

  $self->stopped(time);

  return $self;
}

method metadata() {
  {
    name => $self->name,
    data => $self->data->term,
    mailbox => $self->mailbox->term,
    metadata => $self->metadata->term,
    node => $self->node->name,
    parent => ($self->parent ? $self->parent->node->pid : undef),
    process => $self->node->pid,
    server => $self->server->name,
  }
}

method shutdown() {
  $self->loop->stop(1);

  return $self;
}

1;
