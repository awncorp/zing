use 5.014;

use strict;
use warnings;
use routines;

use lib 't/lib';

use Test::Auto;
use Test::More;
use Test::Zing;

use Config;

=name

Zing

=cut

=tagline

Multi-Process Management System

=cut

=abstract

Actor Toolkit and Multi-Process Management System

=cut

=includes

method: start

=cut

=attributes

scheme: ro, req, Scheme

=cut

=synopsis

  use Zing;

  my $zing = Zing->new(scheme => ['MyApp', [], 1]);

  # $zing->execute;

=cut

=libraries

Zing::Types

=cut

=inherits

Zing::Watcher

=cut

=description

This distribution includes an actor-model architecture toolkit and
Redis-powered multi-process management system which provides primatives for
building powerful reactive, concurrent, distributed and resilient
message-driven applications in Perl 5.

=cut

=method start

The start method builds a L<Zing::Kernel> and executes its event-loop.

=signature start

start() : Kernel

=example-1 start

  # given: synopsis

  $zing->start;

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

  $subs->example(-1, 'start', 'method', fun($tryable) {
    ok my $result = $tryable->result;
    is $MyApp::DATA, 1;

    $result
  });
}

ok 1 and done_testing;
