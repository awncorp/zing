package Zing::Process;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Config;
use FlightRecorder;
use POSIX;

use Zing::Data;
use Zing::Loop;
use Zing::Mailbox;
use Zing::Message;
use Zing::Metadata;
use Zing::Node;
use Zing::Queue;
use Zing::Step;

# VERSION

# ATTRIBUTES

has 'data' => (
  is => 'ro',
  isa => 'Data',
  new => 1,
);

fun new_data($self) {
  Zing::Data->new(name => $self->name)
}

has 'fork' => (
  is => 'ro',
  isa => 'Str',
  def => $Config{d_pseudofork},
);

has 'log' => (
  is => 'ro',
  isa => 'Logger',
  hnd => [qw(info debug warn fatal)],
  new => 1,
);

fun new_log($self) {
  FlightRecorder->new(auto => undef, level => 'info')
}

has 'loop' => (
  is => 'ro',
  isa => 'Loop',
  new => 1,
);

fun new_loop($self) {
  Zing::Loop->new(start => $self->start)
}

has 'mailbox' => (
  is => 'ro',
  isa => 'Mailbox',
  new => 1,
);

fun new_mailbox($self) {
  Zing::Mailbox->new(name => $self->name)
}

has 'metadata' => (
  is => 'ro',
  isa => 'Metadata',
  new => 1,
);

fun new_metadata($self) {
  Zing::Metadata->new(name => $self->name)
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

has 'start' => (
  is => 'ro',
  isa => 'Step',
  new => 1,
);

fun new_start($self) {
  my $mail = Zing::Step->new(
    name => 'mailbox',
    code => fun($step, $loop) { $self->on_mailbox }
  );
  my $meta = $mail->next(Zing::Step->new(
    name => 'metadata',
    code => fun($step, $loop) { $self->on_metadata }
  ));
  my $perform = $meta->next(Zing::Step->new(
    name => 'perform',
    code => fun($step, $loop) { $self->on_perform }
  ));

  $mail
}

has 'started' => (
  is => 'rw',
  isa => 'Int',
  def => 0,
);

has 'timeout' => (
  is => 'ro',
  isa => 'Int',
  def => 10*60,
);

has 'stopped' => (
  is => 'rw',
  isa => 'Int',
  def => 0,
);

# FUNCTION

fun deploy($class, @args) {
  my $pid;
  my $process;

  if ($Config{d_pseudofork}) {
    die "No fork emulation";
  }

  if(!defined($pid = fork)) {
    die "Error on fork: $!";
  }

  # parent
  if ($pid) {
    $process = $class->new(@args, node => Zing::Node->new(pid => $pid));
    return $process;
  }
  # child
  else {
    $pid = $$;
    $process = $class->new(@args, node => Zing::Node->new(pid => $pid));
    return $process->execute;
  }
}

# METHODS

method dequeue(Str $name) {

  return $self->queue($name)->recv;
}

method enqueue(Str $name, HashRef $data) {

  return $self->queue($name)->send($self->message($data));
}

method execute() {
  $self->started(time);

  $self->loop->execute($self);

  $self->stopped(time);

  return $self;
}

method message(HashRef $data) {

  return Zing::Message->new(from => $self->name, payload => $data);
}

method notify(Process $proc, HashRef $data) {

  return $proc->mailbox->send($self->message($data));
}

method perform() {

  return $self;
}

method queue(Str $name) {

  return Zing::Queue->new(name => $name);
}

method receive() {

  return $self;
}

method shutdown() {
  $self->loop->stop(1);

  return $self;
}

method on_mailbox(Any @args) {
  warn 'mailbox handler';
}

method on_metadata(Any @args) {
  warn 'metdata handler';
  $self->metadata->send({heartbeat => time});
}

method on_perform(Any @args) {
  warn 'perform handler';
  $self->perform;
}

1;
