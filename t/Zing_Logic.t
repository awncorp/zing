use 5.014;

use strict;
use warnings;
use routines;

use lib 't/app';
use lib 't/lib';

use Test::Auto;
use Test::More;
use Test::Zing;

=name

Zing::Logic

=cut

=tagline

Process Logic

=cut

=abstract

Process Logic Chain

=cut

=includes

method: flow
method: signals

=cut

=synopsis

  use Zing::Logic;
  use Zing::Process;

  my $process = Zing::Process->new;
  my $logic = Zing::Logic->new(process => $process);

=cut

=libraries

Zing::Types

=cut

=attributes

interupt: ro, opt, Interupt
on_perform: ro, opt, CodeRef
on_receive: ro, opt, CodeRef
on_register: ro, opt, CodeRef
on_reset: ro, opt, CodeRef
on_suicide: ro, opt, CodeRef
process: ro, req, Process

=cut

=description

This package provides the logic (or logic chain) to be executed by the process
event-loop.

=cut

=method flow

The flow method builds and returns the logic flow for the process event-loop.

=signature flow

flow() : Flow

=example-1 flow

  # given: synopsis

  my $flow = $logic->flow;

=cut

=method signals

The signals method builds and returns the process signal handlers.

=signature signals

signals() : HashRef

=example-1 signals

  # given: synopsis

  my $signals = $logic->signals;

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-1, 'flow', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $step_0 = $result;
  is $step_0->name, 'on_reset';
  my $step_1 = $step_0->next;
  is $step_1->name, 'on_register';
  my $step_2 = $step_1->next;
  is $step_2->name, 'on_perform';
  my $step_3 = $step_2->next;
  is $step_3->name, 'on_receive';
  my $step_4 = $step_3->next;
  is $step_4->name, 'on_suicide';
  is $result->bottom->name, 'on_suicide';

  $result
});

$subs->example(-1, 'signals', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply [sort keys %{$result}], [qw(INT QUIT TERM)];

  $result
});

ok 1 and done_testing;
