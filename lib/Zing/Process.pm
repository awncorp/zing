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
use Zing::Metadata;
use Zing::Node;

# VERSION

# ATTRIBUTES

has 'data' => (
  is => 'ro',
  isa => 'Data',
  new => 1,
);

fun new_data($self) {
  Zing::Data->new(name => $self->node->name)
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
  Zing::Mailbox->new(name => $self->node->name)
}

has 'metadata' => (
  is => 'ro',
  isa => 'Metadata',
  new => 1,
);

fun new_metadata($self) {
  Zing::Metadata->new(name => $self->node->name)
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

has 'server' => (
  is => 'ro',
  isa => 'Server',
  new => 1,
);

fun new_server($self) {
  Zing::Server->new
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

method exercise() {
  $self->started(time);

  $self->loop->runonce($self);

  $self->stopped(time);

  return $self;
}

method execute() {
  $self->started(time);

  $self->loop->execute($self);

  $self->stopped(time);

  return $self;
}

method registration() {
  {
    name => $self->name,
    data => $self->data->term,
    mailbox => $self->mailbox->term,
    metadata => $self->metadata->term,
    node => $self->node->name,
    pid => $self->node->pid,
    server => $self->server->name,
  }
}

method shutdown() {
  $self->loop->stop(1);

  return $self;
}

1;
