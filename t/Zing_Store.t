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

Zing::Store

=cut

=tagline

Storage Abstraction

=cut

=abstract

Data Storage Abstraction

=cut

=includes

method: args
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

  use Zing::Store;

  my $store = Zing::Store->new;

  # $store->drop;

=cut

=attributes

encoder: ro, opt, Encoder

=cut

=inherits

Zing::Entity

=cut

=libraries

Zing::Types

=cut

=description

This package provides a data persistence interface to be implemented by data
storage abstractions.

=cut

=method args

The args method parses strings with key/value data (typically from an
environment variable) meant to be used in object construction.

=signature args

args(Str $env) : (Any)

=example-1 args

  # given: synopsis

  [$store->args('port=0001,debug=0')]

=example-2 args

  # given: synopsis

  [$store->args('ports=0001|0002,debug=0')]

=cut

=method drop

The drop method should remove items from the datastore by key.

=signature drop

drop(Str $key) : Int

=example-1 drop

  # given: synopsis

  $store->drop('model');

=cut

=method encode

The encode method should encode and return the data provided in a format
suitable for the underlying storage mechanism.

=signature encode

encode(HashRef $data) : Str

=example-1 encode

  # given: synopsis

  $store->encode({ status => 'ok' });

=cut

=method keys

The keys method should return a list of keys under the namespace provided
including itself.

=signature keys

keys(Str @keys) : ArrayRef[Str]

=example-1 keys

  # given: synopsis

  my $keys = $store->keys('zing:main:global:model:temp');

=cut

=method rpull

The rpull method should pop data off of the bottom of a list in the datastore.

=signature rpull

rpull(Str $key) : Maybe[HashRef]

=example-1 rpull

  # given: synopsis

  $store->rpull('zing:main:global:model:items');

=cut

=method lpull

The lpull method should pop data off of the top of a list in the datastore.

=signature lpull

lpull(Str $key) : Maybe[HashRef]

=example-1 lpull

  # given: synopsis

  $store->lpull('zing:main:global:model:items');

=cut

=method rpush

The rpush method should push data onto the bottom of a list in the datastore.

=signature rpush

rpush(Str $key, HashRef $val) : Int

=example-1 rpush

  # given: synopsis

  $store->rpush('zing:main:global:model:items', { status => 'ok' });

=cut

=method decode

The decode method should decode the data provided and returns the data as a
hashref.

=signature decode

decode(Str $data) : HashRef

=example-1 decode

  # given: synopsis

  $store->decode('{ status => "ok" }');

  # e.g.
  # $ENV{ZING_ENCODER} # Zing::Encoder::Dump

=cut

=method recv

The recv method should fetch and return data from the datastore by its key.

=signature recv

recv(Str $key) : Maybe[HashRef]

=example-1 recv

  # given: synopsis

  $store->recv('zing:main:global:model:temp');

=cut

=method send

The send method should commit data to the datastore with its key and return
truthy (or falsy if not).

=signature send

send(Str $key, HashRef $val) : Str

=example-1 send

  # given: synopsis

  $store->send('zing:main:global:model:temp', { status => 'ok' });

=cut

=method size

The size method should return the size of a list in the datastore.

=signature size

size(Str $key) : Int

=example-1 size

  # given: synopsis

  my $size = $store->size('zing:main:global:model:items');

=cut

=method slot

The slot method should return the data from a list in the datastore by its
position in the list.

=signature slot

slot(Str $key, Int $pos) : Maybe[HashRef]

=example-1 slot

  # given: synopsis

  my $model = $store->slot('zing:main:global:model:items', 0);

=cut

=method test

The test method should return truthy if the specific key exists in the
datastore.

=signature test

test(Str $key) : Int

=example-1 test

  # given: synopsis

  # $store->rpush('zing:main:global:model:items', { status => 'ok' });

  $store->test('zing:main:global:model:items');

=cut

=method lpush

The lpush method should push data onto the top of a list in the datastore.

=signature lpush

lpush(Str $key) : Int

=example-1 lpush

  # given: synopsis

  # $store->rpush('zing:main:global:model:items', { status => '1' });
  # $store->rpush('zing:main:global:model:items', { status => '2' });

  $store->lpush('zing:main:global:model:items', { status => '0' });

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-1, 'args', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, ['port', '0001', 'debug', 0];

  (@$result)
});

$subs->example(-2, 'args', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, ['ports', ['0001', '0002'], 'debug', 0];

  (@$result)
});

$subs->example(-1, 'drop', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"drop" not implemented/;
  });
  ok my $result = $tryable->result;

  1
});

$subs->example(-1, 'encode', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"encode" not implemented/;
  });
  ok my $result = $tryable->result;

  ''
});

$subs->example(-1, 'keys', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"keys" not implemented/;
  });
  ok my $result = $tryable->result;

  []
});

$subs->example(-1, 'rpull', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"rpull" not implemented/;
  });
  ok my $result = $tryable->result;

  {}
});

$subs->example(-1, 'lpull', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"lpull" not implemented/;
  });
  ok my $result = $tryable->result;

  {}
});

$subs->example(-1, 'rpush', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"rpush" not implemented/;
  });
  ok my $result = $tryable->result;

  1
});

$subs->example(-1, 'decode', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"decode" not implemented/;
  });
  ok my $result = $tryable->result;

  {}
});

$subs->example(-1, 'recv', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"recv" not implemented/;
  });
  ok my $result = $tryable->result;

  {}
});

$subs->example(-1, 'send', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"send" not implemented/;
  });
  ok my $result = $tryable->result;

  ''
});

$subs->example(-1, 'size', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"size" not implemented/;
  });
  ok my $result = $tryable->result;

  1
});

$subs->example(-1, 'slot', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"slot" not implemented/;
  });
  ok my $result = $tryable->result;

  {}
});

$subs->example(-1, 'test', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"test" not implemented/;
  });
  ok my $result = $tryable->result;

  1
});

$subs->example(-1, 'lpush', 'method', fun($tryable) {
  $tryable->default(fun ($error) {
    like $error, qr/"lpush" not implemented/;
  });
  ok my $result = $tryable->result;

  1
});

ok 1 and done_testing;
