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

Zing::Store::Hash

=cut

=tagline

Hash Storage

=cut

=abstract

Hash Storage Abstraction

=cut

=includes

method: drop
method: encode
method: keys
method: decode
method: lpull
method: lpush
method: recv
method: rpull
method: rpush
method: send
method: size
method: slot
method: test

=cut

=synopsis

  use Zing::Store::Hash;
  use Zing::Encoder::Json;

  my $hash = Zing::Store::Hash->new(
    encoder => Zing::Encoder::Json->new
  );

  # $hash->drop;

=cut

=libraries

Zing::Types

=cut

=inherits

Zing::Store

=cut

=description

This package provides an in-memory (only) storage adapter for use with data
persistence abstractions.

=cut

=method drop

The drop method removes (drops) the item from the datastore.

=signature drop

drop(Str $key) : Int

=example-1 drop

  # given: synopsis

  $hash->drop('zing:main:global:model:temp');

=cut

=method encode

The encode method encodes and returns the data provided as JSON.

=signature encode

encode(HashRef $data) : Str

=example-1 encode

  # given: synopsis

  $hash->encode({ status => 'ok' });

=cut

=method keys

The keys method returns a list of keys under the namespace of the datastore or
provided key.

=signature keys

keys(Str @keys) : ArrayRef[Str]

=example-1 keys

  # given: synopsis

  my $keys = $hash->keys('zing:main:global:model:temp');

=example-2 keys

  # given: synopsis

  $hash->send('zing:main:global:model:temp', { status => 'ok' });

  my $keys = $hash->keys('zing:main:global:model:temp');

=cut

=method rpull

The rpull method pops data off of the bottom of a list in the datastore.

=signature rpull

rpull(Str $key) : Maybe[HashRef]

=example-1 rpull

  # given: synopsis

  $hash->rpull('zing:main:global:model:items');

=example-2 rpull

  # given: synopsis

  $hash->rpush('zing:main:global:model:items', { status => 1 });
  $hash->rpush('zing:main:global:model:items', { status => 2 });

  $hash->rpull('zing:main:global:model:items');

=cut

=method lpull

The lpull method pops data off of the top of a list in the datastore.

=signature lpull

lpull(Str $key) : Maybe[HashRef]

=example-1 lpull

  # given: synopsis

  $hash->lpull('zing:main:global:model:items');

=example-2 lpull

  # given: synopsis

  $hash->rpush('zing:main:global:model:items', { status => 'ok' });

  $hash->lpull('zing:main:global:model:items');

=cut

=method rpush

The rpush method pushed data onto the bottom of a list in the datastore.

=signature rpush

rpush(Str $key, HashRef $val) : Int

=example-1 rpush

  # given: synopsis

  $hash->rpush('zing:main:global:model:items', { status => 'ok' });

=example-2 rpush

  # given: synopsis

  $hash->rpush('zing:main:global:model:items', { status => 'ok' });

  $hash->rpush('zing:main:global:model:items', { status => 'ok' });

=cut

=method decode

The decode method decodes the JSON data provided and returns the data as a hashref.

=signature decode

decode(Str $data) : HashRef

=example-1 decode

  # given: synopsis

  $hash->decode('{"status":"ok"}');

=cut

=method recv

The recv method fetches and returns data from the datastore by its key.

=signature recv

recv(Str $key) : Maybe[HashRef]

=example-1 recv

  # given: synopsis

  $hash->recv('zing:main:global:model:temp');

=example-2 recv

  # given: synopsis

  $hash->send('zing:main:global:model:temp', { status => 'ok' });

  $hash->recv('zing:main:global:model:temp');

=cut

=method send

The send method commits data to the datastore with its key and returns truthy.

=signature send

send(Str $key, HashRef $val) : Str

=example-1 send

  # given: synopsis

  $hash->send('zing:main:global:model:temp', { status => 'ok' });

=cut

=method size

The size method returns the size of a list in the datastore.

=signature size

size(Str $key) : Int

=example-1 size

  # given: synopsis

  my $size = $hash->size('zing:main:global:model:items');

=example-2 size

  # given: synopsis

  $hash->rpush('zing:main:global:model:items', { status => 'ok' });

  my $size = $hash->size('zing:main:global:model:items');

=cut

=method slot

The slot method returns the data from a list in the datastore by its index.

=signature slot

slot(Str $key, Int $pos) : Maybe[HashRef]

=example-1 slot

  # given: synopsis

  my $model = $hash->slot('zing:main:global:model:items', 0);

=example-2 slot

  # given: synopsis

  $hash->rpush('zing:main:global:model:items', { status => 'ok' });

  my $model = $hash->slot('zing:main:global:model:items', 0);

=cut

=method test

The test method returns truthy if the specific key (or datastore) exists.

=signature test

test(Str $key) : Int

=example-1 test

  # given: synopsis

  $hash->rpush('zing:main:global:model:items', { status => 'ok' });

  $hash->test('zing:main:global:model:items');

=example-2 test

  # given: synopsis

  $hash->drop('zing:main:global:model:items');

  $hash->test('zing:main:global:model:items');

=cut

=method lpush

The lpush method pushed data onto the top of a list in the datastore.

=signature lpush

lpush(Str $key, HashRef $val) : Int

=example-1 lpush

  # given: synopsis

  $hash->lpush('zing:main:global:model:items', { status => '1' });

=example-2 lpush

  # given: synopsis

  $hash->lpush('zing:main:global:model:items', { status => '0' });

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-1, 'drop', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);
  is $result, 0;

  $result
});

$subs->example(-1, 'encode', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  like $result, qr/"status"\s*:\s*"ok"/;

  $result
});

$subs->example(-1, 'keys', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is @$result, 0;

  $result
});

$subs->example(-2, 'keys', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is @$result, 1;

  $result
});

$subs->example(-1, 'rpull', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-2, 'rpull', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 2};

  $result
});

$subs->example(-1, 'lpull', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 1};

  $result
});

$subs->example(-2, 'lpull', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 'ok'};

  $result
});

$subs->example(-1, 'rpush', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

$subs->example(-2, 'rpush', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 3;

  $result
});

$subs->example(-1, 'decode', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 'ok'};

  $result
});

$subs->example(-1, 'recv', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-2, 'recv', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 'ok'};

  $result
});

$subs->example(-1, 'send', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 'OK';

  $result
});

$subs->example(-1, 'size', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 3;

  $result
});

$subs->example(-2, 'size', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 4;

  $result
});

$subs->example(-1, 'slot', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-2, 'slot', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 'ok'};

  $result
});

$subs->example(-1, 'test', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-2, 'test', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-1, 'lpush', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

$subs->example(-2, 'lpush', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 2;
  my $hash = Zing::Store::Hash->new(
    encoder => Zing::Encoder::Json->new,
  );
  my $top = $hash->lpull('zing:main:global:model:items');
  is_deeply $top, { status => '0' };

  $result
});

ok 1 and done_testing;
