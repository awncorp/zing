use 5.014;

use strict;
use warnings;
use routines;

use lib 't/app';
use lib 't/lib';

use Test::Auto;
use Test::More;
use Test::Trap;
use Test::Zing;

use Config;
use File::Temp;

=name

Zing::Cli

=cut

=tagline

Command-line Interface

=cut

=abstract

Command-line Application Administration

=cut

=includes

method: main

=cut

=synopsis

  use Zing::Cli;

  my $c = Zing::Cli->new;

  # $c->handle('main');

=cut

=libraries

Zing::Types

=cut

=inherits

Data::Object::Cli

=cut

=description

This package provides a command-line interface for managing L<Zing>
applications. See the L<zing> documentation for interface arguments and
options.

=cut

=method main

The main method executes the command-line interface and displays help text or
launches applications.

=signature main

main() : Any

=example-1 main

  # given: synopsis

  # e.g.
  # zing once -I t/lib -a t/app

  $c->handle('main'); # good

=example-2 main

  # given: synopsis

  # e.g.
  # zing unce -I t/lib -a t/app

  $c->handle('main'); # fail (not exist)

=cut

package main;

SKIP: {
  skip 'Skipping systems using fork emulation' if $Config{d_pseudofork};

  my $test = testauto(__FILE__);

  my $subs = $test->standard;

  $subs->synopsis(fun($tryable) {
    ok my $result = $tryable->result;

    $result
  });

  $subs->example(-1, 'main', 'method', fun($tryable) {
    my $result;

    local @ARGV = (
      'once', '-I', 't/lib', '-a', 't/app', '-p', File::Temp->newdir
    );
    trap { ok !($result = $tryable->result) }; # exit 0 is good

    $result
  });

  $subs->example(-2, 'main', 'method', fun($tryable) {
    my $result;

    local @ARGV = (
      'unce', '-I', 't/lib', '-a', 't/app', '-p', File::Temp->newdir
    );
    trap { ok ($result = $tryable->result) }; # exit 1 is fail

    $result
  });
}

ok 1 and done_testing;
