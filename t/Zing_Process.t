use 5.014;

use strict;
use warnings;
use routines;

use lib 't/app';
use lib 't/lib';

use Test::Auto;
use Test::More;
use Test::Zing;

use Config;

=name

Zing::Process

=cut

=tagline

Processing Unit

=abstract

Processing Unit and Actor Abstraction

=cut

=includes

method: defer
method: destroy
method: exercise
method: execute
method: metadata
method: shutdown
method: spawn
method: winddown

=cut

=synopsis

  use Zing::Process;

  my $process = Zing::Process->new;

  # $process->execute;

=cut

=libraries

Zing::Types

=cut

=attributes

cleanup: ro, opt, Str
data: ro, opt, Str
journal: ro, opt, Str
log: ro, opt, Str
logic: ro, opt, Str
loop: ro, opt, Str
mailbox: ro, opt, Str
name: ro, opt, Str
node: ro, opt, Str
parent: ro, opt, Str
registry: ro, opt, Str
server: ro, opt, Str
signals: ro, opt, Str
started: ro, opt, Str
stopped: ro, opt, Str

=cut

=description

This package provides an actor abstraction which serve as a cooperative
concurrent computational unit in an actor-model architecture.

=cut

=method defer

The defer method allows a process to sends a message to itself for later
processing.

=signature defer

defer(HashRef $data) : Object

=example-1 defer

  # given: synopsis

  $process->defer({ task => { launch => time } });

=cut

=method destroy

The destroy method de-registers the process and drops the process-specific data
stores.

=signature destroy

destroy() : Object

=example-1 destroy

  # given: synopsis

  $process->destroy;

=cut

=method exercise

The exercise method executes the event-loop but stops after one iteration.

=signature exercise

exercise() : Object

=example-1 exercise

  # given: synopsis

  $process->exercise;

=cut

=method execute

The execute method executes the process event-loop indefinitely.

=signature execute

execute() : Object

=example-1 execute

  # given: synopsis

  $process->execute;

=cut

=method metadata

The metadata method returns metadata specific to the process.

=signature metadata

metadata() : HashRef

=example-1 metadata

  # given: synopsis

  $process->metadata;

=cut

=method shutdown

The shutdown method haults the process event-loop immediately.

=signature shutdown

shutdown() : Object

=example-1 shutdown

  # given: synopsis

  $process->shutdown;

=cut

=method spawn

The spawn method forks a scheme and returns a L<Zing::Fork> handler.

=signature spawn

spawn(Scheme $scheme) : Fork

=example-1 spawn

  # given: synopsis

  $process->spawn(['MyApp', [], 1]);

=cut

=method winddown

The winddown method haults the process event-loop after the current iteration.

=signature winddown

winddown() : Object

=example-1 winddown

  # given: synopsis

  $process->winddown;

=cut

package MyApp;

use parent 'Zing::Single';

our $DATA = 0;

sub perform {
  $DATA++
}

package main;

SKIP: {
  skip 'Skipping systems using fork emulation' if $Config{d_pseudofork};

  my $test = testauto(__FILE__);

  my $subs = $test->standard;

  $subs->synopsis(fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });

  $subs->example(-1, 'defer', 'method', fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });

  $subs->example(-1, 'destroy', 'method', fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });

  $subs->example(-1, 'exercise', 'method', fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });

  $subs->example(-1, 'execute', 'method', fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });

  $subs->example(-1, 'metadata', 'method', fun($tryable) {
    ok my $result = $tryable->result;
    like $result->{data}, qr/zing:\d+\.\d+\.\d+\.\d+:\d+:\d+:\d+:data/;
    like $result->{mailbox}, qr/zing:\d+\.\d+\.\d+\.\d+:\d+:\d+:\d+:mailbox/;
    like $result->{name}, qr/\d+\.\d+\.\d+\.\d+:\d+:\d+:\d+/;
    like $result->{node}, qr/\d+:\d+/;
    ok !$result->{parent};
    like $result->{process}, qr/\d+/;
    like $result->{server}, qr/\d+\.\d+\.\d+\.\d+/;
    $result
  });

  $subs->example(-1, 'shutdown', 'method', fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });

  $subs->example(-1, 'spawn', 'method', fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });

  $subs->example(-1, 'winddown', 'method', fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });
}

ok 1 and done_testing;
