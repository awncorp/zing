package Zing::Term;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Server;

use Carp ();
use Scalar::Util ();

use overload '""' => 'string';

# VERSION

# ATTRIBUTES

has 'facets' => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  opt => 1,
);

has 'handle' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'symbol' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'bucket' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'system' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'target' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

# BUILDERS

state $symbols = {
  'Zing::Channel'  => 'channel',
  'Zing::Data'     => 'data',
  'Zing::Domain'   => 'domain',
  'Zing::Kernel'   => 'kernel',
  'Zing::KeyVal'   => 'keyval',
  'Zing::Lookup'   => 'lookup',
  'Zing::Mailbox'  => 'mailbox',
  'Zing::Process'  => 'process',
  'Zing::PubSub'   => 'pubsub',
  'Zing::Queue'    => 'queue',
  'Zing::Registry' => 'registry',
  'Zing::Repo'     => 'repo',
};

fun BUILDARGS($self, $item, @data) {
  my $args = {};

  if (Scalar::Util::blessed($item)) {
    my $local = sprintf 'local(%s)', Zing::Server->new->name;

    @data = map {split /:/} @data;

    if ($item->isa('Zing::Data')) {
      my ($bucket, @facets) = split /:/, $item->name;
      $args->{symbol} = $symbols->{'Zing::Data'};
      $args->{target} = $local;
      $args->{bucket} = $bucket;
      $args->{facets} = [@facets, @data];
    }
    elsif ($item->isa('Zing::Lookup')) {
      $args->{symbol} = $symbols->{'Zing::Lookup'};
      $args->{target} = $item->target eq 'global' ? 'global' : $local;
      $args->{bucket} = $item->name;
      $args->{facets} = [@data];
    }
    elsif ($item->isa('Zing::Domain')) {
      $args->{symbol} = $symbols->{'Zing::Domain'};
      $args->{target} = $item->target eq 'global' ? 'global' : $local;
      $args->{bucket} = $item->name;
      $args->{facets} = [@data];
    }
    elsif ($item->isa('Zing::Channel')) {
      $args->{symbol} = $symbols->{'Zing::Channel'};
      $args->{target} = $item->target eq 'global' ? 'global' : $local;
      $args->{bucket} = $item->name;
      $args->{facets} = [@data];
    }
    elsif ($item->isa('Zing::Kernel')) {
      my ($bucket, @facets) = split /:/, $item->name;
      $args->{symbol} = $symbols->{'Zing::Kernel'};
      $args->{target} = $local;
      $args->{bucket} = $bucket;
      $args->{facets} = [@facets, @data];
    }
    elsif ($item->isa('Zing::Mailbox')) {
      my ($bucket, @facets) = split /:/, $item->name;
      $args->{symbol} = $symbols->{'Zing::Mailbox'};
      $args->{target} = 'global';
      $args->{bucket} = $bucket;
      $args->{facets} = [@facets, @data];
    }
    elsif ($item->isa('Zing::Process')) {
      my ($bucket, @facets) = split /:/, $item->name;
      $args->{symbol} = $symbols->{'Zing::Process'};
      $args->{target} = $local;
      $args->{bucket} = $bucket;
      $args->{facets} = [@facets, @data];
    }
    elsif ($item->isa('Zing::Queue')) {
      $args->{symbol} = $symbols->{'Zing::Queue'};
      $args->{target} = $item->target eq 'global' ? 'global' : $local;
      $args->{bucket} = $item->name;
      $args->{facets} = [@data];
    }
    elsif ($item->isa('Zing::Registry')) {
      $args->{symbol} = $symbols->{'Zing::Registry'};
      $args->{target} = $item->target eq 'global' ? 'global' : $local;
      $args->{bucket} = $item->name;
      $args->{facets} = [@data];
    }
    elsif ($item->isa('Zing::KeyVal')) {
      $args->{symbol} = $symbols->{'Zing::KeyVal'};
      $args->{target} = $item->target eq 'global' ? 'global' : $local;
      $args->{bucket} = $item->name;
      $args->{facets} = [@data];
    }
    elsif ($item->isa('Zing::PubSub')) {
      $args->{symbol} = $symbols->{'Zing::PubSub'};
      $args->{target} = $item->target eq 'global' ? 'global' : $local;
      $args->{bucket} = $item->name;
      $args->{facets} = [@data];
    }
    elsif ($item->isa('Zing::Repo')) {
      $args->{symbol} = $symbols->{'Zing::Repo'};
      $args->{target} = $item->target eq 'global' ? 'global' : $local;
      $args->{bucket} = $item->name;
      $args->{facets} = [@data];
    }
    else {
      Carp::confess qq(Error in term: Unrecognizable "object");
    }
    $args->{handle} = ($item->env->handle || 'main') =~ s/\W/-/gr;
    $args->{system} = 'zing';
  }
  elsif(defined $item && !ref $item) {
    my $schema = [split /:/, "$item", 6];

    my $system = $schema->[0];
    my $handle = $schema->[1];
    my $target = $schema->[2];
    my $symbol = $schema->[3];
    my $bucket = $schema->[4];
    my $extras = $schema->[5];

    my $facets = [split /:/, $extras || ''];

    unless ($system eq 'zing') {
      Carp::confess qq(Error in term: Unrecognizable "system" in: $item);
    }
    unless ($target =~ m{^(global|local\(\d+\.\d+\.\d+\.\d+\))$}) {
      Carp::confess qq(Error in term: Unrecognizable "target" ($target) in: $item);
    }
    unless (grep {$_ eq $symbol} values %$symbols) {
      Carp::confess qq(Error in term: Unrecognizable "symbol" ($symbol) in: $item);
    }

    $args->{system} = $system;
    $args->{handle} = $handle;
    $args->{target} = $target;
    $args->{symbol} = $symbol;
    $args->{bucket} = $bucket;
    $args->{facets} = $facets;
  }
  else {
    Carp::confess 'Unrecognizable Zing term provided';
  }

  return $args;
}

# METHODS

method channel() {
  unless ($self->symbol eq 'channel') {
    Carp::confess 'Error in term: not a "channel"';
  }

  return $self->string;
}

method data() {
  unless ($self->symbol eq 'data') {
    Carp::confess 'Error in term: not a "data" term';
  }

  return $self->string;
}

method domain() {
  unless ($self->symbol eq 'domain') {
    Carp::confess 'Error in term: not a "domain" term';
  }

  return $self->string;
}

method kernel() {
  unless ($self->symbol eq 'kernel') {
    Carp::confess 'Error in term: not a "kernel" term';
  }

  return $self->string;
}

method keyval() {
  unless ($self->symbol eq 'keyval') {
    Carp::confess 'Error in term: not a "keyval" term';
  }

  return $self->string;
}

method lookup() {
  unless ($self->symbol eq 'lookup') {
    Carp::confess 'Error in term: not a "lookup" term';
  }

  return $self->string;
}

method mailbox() {
  unless ($self->symbol eq 'mailbox') {
    Carp::confess 'Error in term: not a "mailbox" term';
  }

  return $self->string;
}

method process() {
  unless ($self->symbol eq 'process') {
    Carp::confess 'Error in term: not a "process" term';
  }

  return $self->string;
}

method pubsub() {
  unless ($self->symbol eq 'pubsub') {
    Carp::confess 'Error in term: not a "pubsub" term';
  }

  return $self->string;
}

method queue() {
  unless ($self->symbol eq 'queue') {
    Carp::confess 'Error in term: not a "queue" term';
  }

  return $self->string;
}

method registry() {
  unless ($self->symbol eq 'registry') {
    Carp::confess 'Error in term: not a "registry" term';
  }

  return $self->string;
}

method repo() {
  unless ($self->symbol eq 'repo') {
    Carp::confess 'Error in term: not a "repo" term';
  }

  return $self->string;
}

method string() {
  my $system = $self->system;
  my $handle = $self->handle;
  my $target = $self->target;
  my $symbol = $self->symbol;
  my $bucket = $self->bucket;
  my $facets = $self->facets || [];

  return lc join ':', $system, $handle, $target, $symbol, $bucket, @$facets;
}

1;
