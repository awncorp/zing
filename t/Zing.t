use 5.014;

use strict;
use warnings;
use routines;

use Test::Auto;
use Test::More;

=name

Zing

=cut

=abstract

Multi-Process Management System

=cut

=includes

=cut

=synopsis

  use Zing;

  my $z = Zing->new;

=cut

=libraries

Zing::Types

=cut

=inherits

App::Spec::Run::Cmd

=cut

=description

This package provides an actor-model inspired Redis-powered multi-process
management system that provides a simple framework for managing job queues and
workers, supervising processes, and facilitating interprocess communication.

=cut

=method data

The data method returns the Zing system CLI specification as a YAML string to
be provided to L<App::Spec>.

=signature data

data() : Str

=example-1 data

  # given: synopsis

  $z->data;

=cut

=method space

The space method returns a L<Data::Object::Space> object representing the Zing
namespace.

=signature space

space() : Space

=example-1 space

  # given: synopsis

  $z->space;

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

# $subs->example(-1, 'data', 'method', fun($tryable) {
#   ok my $result = $tryable->result;

#   $result
# });

# $subs->example(-1, 'space', 'method', fun($tryable) {
#   ok my $result = $tryable->result;
#   ok $result->isa('Data::Object::Space');
#   is $result->package, 'Zing';

#   $result
# });

ok 1 and done_testing;
