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

Zing::Term

=cut

=tagline

Resource Representation

=abstract

Resource Representation

=cut

=includes

method: channel
method: data
method: domain
method: kernel
method: keyval
method: mailbox
method: meta
method: process
method: pubsub
method: queue
method: repo
method: string

=cut

=synopsis

  use Zing::KeyVal;
  use Zing::Term;

  my $term = Zing::Term->new(Zing::KeyVal->new(name => 'nodes'));

  # $term->keyval;

=cut

=libraries

Zing::Types

=cut

=attributes

handle: ro, req, Str
symbol: ro, req, Str
bucket: ro, req, Str
system: ro, req, Str
target: ro, req, Str

=cut

=description

This package provides a mechanism for generating and validating (global and
local) resource identifiers.

=cut

=method channel

The channel method validates and returns a "channel" resource identifier.

=signature channel

channel() : Str

=example-1 channel

  use Zing::Channel;

  Zing::Term->new(Zing::Channel->new(name => 'chat'));

  # $term->channel;

=cut

=method data

The data method validates and returns a "data" resource identifier.

=signature data

data() : Str

=example-1 data

  use Zing::Data;
  use Zing::Process;

  Zing::Term->new(Zing::Data->new(name => '0.0.0.0'));

  # $term->data;

=cut

=method domain

The domain method validates and returns a "domain" resource identifier.

=signature domain

domain() : Str

=example-1 domain

  use Zing::Domain;

  Zing::Term->new(Zing::Domain->new(name => 'transaction'));

  # $term->domain;

=cut

=method kernel

The kernel method validates and returns a "kernel" resource identifier.

=signature kernel

kernel() : Str

=example-1 kernel

  use Zing::Kernel;

  Zing::Term->new(Zing::Kernel->new(scheme => ['MyApp', [], 1]));

  # $term->kernel;

=cut

=method keyval

The keyval method validates and returns a "keyval" resource identifier.

=signature keyval

keyval() : Str

=example-1 keyval

  use Zing::KeyVal;

  Zing::Term->new(Zing::KeyVal->new(name => 'listeners'));

  # $term->keyval;

=cut

=method mailbox

The mailbox method validates and returns a "mailbox" resource identifier.

=signature mailbox

mailbox() : Str

=example-1 mailbox

  use Zing::Mailbox;
  use Zing::Process;

  Zing::Term->new(Zing::Mailbox->new(name => '0.0.0.0'));

  # $term->mailbox;

=cut

=method meta

The meta method validates and returns a "meta" resource identifier.

=signature meta

meta() : Str

=example-1 meta

  use Zing::Meta;

  Zing::Term->new(Zing::Meta->new(name => 'random'));

  # $term->meta;

=cut

=method process

The process method validates and returns a "process" resource identifier.

=signature process

process() : Str

=example-1 process

  use Zing::Process;

  Zing::Term->new(Zing::Process->new);

  # $term->process;

=cut

=method pubsub

The pubsub method validates and returns a "pubsub" resource identifier.

=signature pubsub

pubsub() : Str

=example-1 pubsub

  use Zing::PubSub;

  Zing::Term->new(Zing::PubSub->new(name => 'operations'));

  # $term->pubsub;

=cut

=method queue

The queue method validates and returns a "queue" resource identifier.

=signature queue

queue() : Str

=example-1 queue

  use Zing::Queue;

  Zing::Term->new(Zing::Queue->new(name => 'workflows'));

  # $term->queue;

=cut

=method repo

The repo method validates and returns a "repo" resource identifier.

=signature repo

repo() : Str

=example-1 repo

  use Zing::Repo;

  Zing::Term->new(Zing::Repo->new(name => 'miscellaneous'));

  # $term->repo;

=cut

=method string

The string method returns a resource identifier. This method is called
automatically when the object is used as a string.

=signature string

string() : Str

=example-1 string

  # given: synopsis

  $term->string;

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'keyval';
  is $bucket, 'nodes';

  $result
});

$subs->example(-1, 'channel', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'channel';
  is $bucket, 'chat';

  is "$result", 'zing:main:global:channel:chat';

  "$result"
});

$subs->example(-1, 'data', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'data';
  is $bucket, '0.0.0.0';

  is "$result", "zing:main:global:data:$bucket";

  "$result"
});

$subs->example(-1, 'domain', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'domain';
  is $bucket, 'transaction';

  is "$result", 'zing:main:global:domain:transaction';

  "$result"
});

$subs->example(-1, 'kernel', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'kernel';
  like $bucket, qr/^\w{40}$/;

  is "$result", "zing:main:global:kernel:$bucket";

  "$result"
});

$subs->example(-1, 'keyval', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'keyval';
  is $bucket, 'listeners';

  is "$result", 'zing:main:global:keyval:listeners';

  "$result"
});

$subs->example(-1, 'mailbox', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'mailbox';
  is $bucket, '0.0.0.0';

  is "$result", "zing:main:global:mailbox:$bucket";

  "$result"
});

$subs->example(-1, 'meta', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'meta';
  is $bucket, 'random';

  is "$result", 'zing:main:global:meta:random';

  "$result"
});

$subs->example(-1, 'process', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'process';
  like $bucket, qr/^\w{40}$/;

  is "$result", "zing:main:global:process:$bucket";

  "$result"
});

$subs->example(-1, 'pubsub', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  "$result"
});

$subs->example(-1, 'queue', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'queue';
  is $bucket, 'workflows';

  is "$result", 'zing:main:global:queue:workflows';

  "$result"
});

$subs->example(-1, 'repo', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  my $system = $result->system;
  my $handle = $result->handle;
  my $target = $result->target;
  my $symbol = $result->symbol;
  my $bucket = $result->bucket;

  is $system, 'zing';
  is $handle, 'main';
  is $target, 'global';
  is $symbol, 'repo';
  is $bucket, 'miscellaneous';

  is "$result", 'zing:main:global:repo:miscellaneous';

  "$result"
});

$subs->example(-1, 'string', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  is "$result", 'zing:main:global:keyval:nodes';

  $result
});

ok 1 and done_testing;
