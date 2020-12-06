package Zing::App;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

# VERSION

# ATTRIBUTES

has env => (
  is => 'ro',
  isa => 'Env',
  new => 1,
);

fun new_env($self) {
  require Zing::Env; Zing::Env->new(app => $self);
}

has name => (
  is => 'ro',
  isa => 'Str',
  def => 'Zing',
);

has node => (
  is => 'ro',
  isa => 'Node',
  new => 1,
);

fun new_node($self) {
  require Zing::Node; Zing::Node->new(app => $self);
}

# METHODS

method id() {
  return $self->node->identifier;
}

method cartridge(Any @args) {
  return $self->reify($self->cartridge_specification(@args));
}

method cartridge_namespace() {
  return [$self->name, 'cartridge'];
}

method cartridge_specification(Any @args) {
  return [$self->cartridge_namespace, [@args]];
}

method channel(Any @args) {
  return $self->reify($self->channel_specification(@args));
}

method channel_namespace() {
  return [$self->name, 'channel'];
}

method channel_specification(Any @args) {
  return [$self->channel_namespace, [@args]];
}

method cursor(Any @args) {
  return $self->reify($self->cursor_specification(@args));
}

method cursor_namespace() {
  return [$self->name, 'cursor'];
}

method cursor_specification(Any @args) {
  return [$self->cursor_namespace, [@args]];
}

method daemon(Any @args) {
  return $self->reify($self->daemon_specification(@args));
}

method daemon_namespace() {
  return [$self->name, 'daemon'];
}

method daemon_specification(Any @args) {
  return [$self->daemon_namespace, [@args]];
}

method data(Any @args) {
  return $self->reify($self->data_specification(@args));
}

method data_namespace() {
  return [$self->name, 'data'];
}

method data_specification(Any @args) {
  return [$self->data_namespace, [@args]];
}

method domain(Any @args) {
  return $self->reify($self->domain_specification(@args));
}

method domain_namespace() {
  return [$self->name, 'domain'];
}

method domain_specification(Any @args) {
  return [$self->domain_namespace, [@args]];
}

method fork(Any @args) {
  return $self->reify($self->fork_specification(@args));
}

method fork_namespace() {
  return [$self->name, 'fork'];
}

method fork_specification(Any @args) {
  return [$self->fork_namespace, [@args]];
}

method journal(Any @args) {
  return $self->reify($self->journal_specification(@args));
}

method journal_namespace() {
  return [$self->name, 'journal'];
}

method journal_specification(Any @args) {
  return [$self->journal_namespace, [@args]];
}

method kernel(Any @args) {
  return $self->reify($self->kernel_specification(@args));
}

method kernel_namespace() {
  return [$self->name, 'kernel'];
}

method kernel_specification(Any @args) {
  return [$self->kernel_namespace, [@args]];
}

method keyval(Any @args) {
  return $self->reify($self->keyval_specification(@args));
}

method keyval_namespace() {
  return [$self->name, 'keyval'];
}

method keyval_specification(Any @args) {
  return [$self->keyval_namespace, [@args]];
}

method launcher(Any @args) {
  return $self->reify($self->launcher_specification(@args));
}

method launcher_namespace() {
  return [$self->name, 'launcher'];
}

method launcher_specification(Any @args) {
  return [$self->launcher_namespace, [@args]];
}

method logger(Any @args) {
  require FlightRecorder; FlightRecorder->new(level => 'info', @args);
}

method lookup(Any @args) {
  return $self->reify($self->lookup_specification(@args));
}

method lookup_namespace() {
  return [$self->name, 'lookup'];
}

method lookup_specification(Any @args) {
  return [$self->lookup_namespace, [@args]];
}

method mailbox(Any @args) {
  return $self->reify($self->mailbox_specification(@args));
}

method mailbox_namespace() {
  return [$self->name, 'mailbox'];
}

method mailbox_specification(Any @args) {
  return [$self->mailbox_namespace, [@args]];
}

method process(Any @args) {
  return $self->reify($self->process_specification(@args));
}

method process_namespace() {
  return [$self->name, 'process'];
}

method process_specification(Any @args) {
  return [$self->process_namespace, [@args]];
}

method pubsub(Any @args) {
  return $self->reify($self->pubsub_specification(@args));
}

method pubsub_namespace() {
  return [$self->name, 'pubsub'];
}

method pubsub_specification(Any @args) {
  return [$self->pubsub_namespace, [@args]];
}

method queue(Any @args) {
  return $self->reify($self->queue_specification(@args));
}

method queue_namespace() {
  return [$self->name, 'queue'];
}

method queue_specification(Any @args) {
  return [$self->queue_namespace, [@args]];
}

method registry(Any @args) {
  return $self->reify($self->registry_specification(@args));
}

method registry_namespace() {
  return [$self->name, 'registry'];
}

method registry_specification(Any @args) {
  return [$self->registry_namespace, [@args]];
}

method reify(Tuple[ArrayRef, ArrayRef] $spec) {
  return $self->space(@{$spec->[0]})->build(@{$spec->[1]}, env => $self->env);
}

method repo(Any @args) {
  return $self->reify($self->repo_specification(@args));
}

method repo_namespace() {
  return [$self->name, 'repo'];
}

method repo_specification(Any @args) {
  return [$self->repo_namespace, [@args]];
}

method ring(Any @args) {
  return $self->reify($self->ring_specification(@args));
}

method ring_namespace() {
  return [$self->name, 'ring'];
}

method ring_specification(Any @args) {
  return [$self->ring_namespace, [@args]];
}

method ringer(Any @args) {
  return $self->reify($self->ringer_specification(@args));
}

method ringer_namespace() {
  return [$self->name, 'ringer'];
}

method ringer_specification(Any @args) {
  return [$self->ringer_namespace, [@args]];
}

method savepoint(Any @args) {
  return $self->reify($self->savepoint_specification(@args));
}

method savepoint_namespace() {
  return [$self->name, 'savepoint'];
}

method savepoint_specification(Any @args) {
  return [$self->savepoint_namespace, [@args]];
}

method scheduler(Any @args) {
  return $self->reify($self->scheduler_specification(@args));
}

method scheduler_namespace() {
  return [$self->name, 'scheduler'];
}

method scheduler_specification(Any @args) {
  return [$self->scheduler_namespace, [@args]];
}

method simple(Any @args) {
  return $self->reify($self->simple_specification(@args));
}

method simple_namespace() {
  return [$self->name, 'simple'];
}

method simple_specification(Any @args) {
  return [$self->simple_namespace, [@args]];
}

method single(Any @args) {
  return $self->reify($self->single_specification(@args));
}

method single_namespace() {
  return [$self->name, 'single'];
}

method single_specification(Any @args) {
  return [$self->single_namespace, [@args]];
}

method space(Str @args) {
  return Data::Object::Space->new(join '/', (@args ? @args : $self->name));
}

method spawner(Any @args) {
  return $self->reify($self->spawner_specification(@args));
}

method spawner_namespace() {
  return [$self->name, 'spawner'];
}

method spawner_specification(Any @args) {
  return [$self->spawner_namespace, [@args]];
}

method store(Any @args) {
  return $self->reify($self->store_specification(@args));
}

method store_namespace() {
  return [$self->env->store];
}

method store_specification(Any @args) {
  return [$self->store_namespace, [@args]];
}

method term(Any @args) {
  require Zing::Term; Zing::Term->new(@args);
}

method timer(Any @args) {
  return $self->reify($self->timer_specification(@args));
}

method timer_namespace() {
  return [$self->name, 'timer'];
}

method timer_specification(Any @args) {
  return [$self->timer_namespace, [@args]];
}

method watcher(Any @args) {
  return $self->reify($self->watcher_specification(@args));
}

method watcher_namespace() {
  return [$self->name, 'watcher'];
}

method watcher_specification(Any @args) {
  return [$self->watcher_namespace, [@args]];
}

method worker(Any @args) {
  return $self->reify($self->worker_specification(@args));
}

method worker_namespace() {
  return [$self->name, 'worker'];
}

method worker_specification(Any @args) {
  return [$self->worker_namespace, [@args]];
}

method zang() {
  return ref($self)->new(name => 'Zing/Zang');
}

method zing(Any @args) {
  require Zing; Zing->new(@args);
}

1;
