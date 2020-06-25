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

Zing::Dropbox

=cut

=tagline

Transient Store

=cut

=abstract

Transient Key/Value Store

=cut

=includes

method: poll

=cut

=synopsis

  use Zing::Dropbox;

  my $dropbox = Zing::Dropbox->new;

=cut

=libraries

Zing::Types

=cut

=inherits

Zing::KeyVal

=cut

=description

This package provides a general-purpose key/value store for transient data.

=cut

=method poll

The poll method watches (i.e. polls) the key specified for C<n> seconds and
either a) returns the data once it's received and drops the key, or b) returns
undefined.

=signature poll

poll(Str $name, Int $secs) : Maybe[HashRef]

=example-1 poll

  # given: synopsis

  $dropbox->poll(ephemeral => 0);

=example-2 poll

  # given: synopsis

  # some other process places the data
  $dropbox->send(ephemeral => { data => '...' });

  # poll "ephemeral" for 10 secs, except the data was already placed
  $dropbox->poll(ephemeral => 10);

=example-3 poll

  # given: synopsis

  # poll "ephemeral" for 10 secs
  $dropbox->poll(ephemeral => 10);

  # some other process places the data
  $dropbox->send(ephemeral => { data => '...' });

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-1, 'poll', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-2, 'poll', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, { data => '...' };

  $result
});

$subs->example(-3, 'poll', 'method', fun($tryable) {
  my $dropbox = Zing::Dropbox->new;
  $dropbox->send(ephemeral => { data => '...' });
  ok my $result = $tryable->result;

  { data => '...' }
});

ok 1 and done_testing;
