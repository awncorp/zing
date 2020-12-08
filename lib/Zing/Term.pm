package Zing::Term;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

use Carp ();
use Scalar::Util ();

use overload '""' => 'string';

# VERSION

# ATTRIBUTES

has 'handle' => (
  is => 'ro',
  isa => 'Name',
  req => 1,
);

has 'symbol' => (
  is => 'ro',
  isa => 'Name',
  req => 1,
);

has 'bucket' => (
  is => 'ro',
  isa => 'Name',
  req => 1,
);

has 'system' => (
  is => 'ro',
  isa => 'Name',
  req => 1,
);

has 'target' => (
  is => 'ro',
  isa => 'Name',
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
  'Zing::Meta'     => 'meta',
  'Zing::Process'  => 'process',
  'Zing::PubSub'   => 'pubsub',
  'Zing::Queue'    => 'queue',
  'Zing::Repo'     => 'repo',
};

fun BUILDARGS($self, $item, @data) {
  my $args = {};

  if (Scalar::Util::blessed($item)) {
    if ($item->isa('Zing::Data')) {
      $args->{symbol} = $symbols->{'Zing::Data'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Lookup')) {
      $args->{symbol} = $symbols->{'Zing::Lookup'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Domain')) {
      $args->{symbol} = $symbols->{'Zing::Domain'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Channel')) {
      $args->{symbol} = $symbols->{'Zing::Channel'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Kernel')) {
      $args->{symbol} = $symbols->{'Zing::Kernel'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Mailbox')) {
      $args->{symbol} = $symbols->{'Zing::Mailbox'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Process')) {
      $args->{symbol} = $symbols->{'Zing::Process'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Queue')) {
      $args->{symbol} = $symbols->{'Zing::Queue'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Meta')) {
      $args->{symbol} = $symbols->{'Zing::Meta'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::KeyVal')) {
      $args->{symbol} = $symbols->{'Zing::KeyVal'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::PubSub')) {
      $args->{symbol} = $symbols->{'Zing::PubSub'};
      $args->{bucket} = $item->name;
    }
    elsif ($item->isa('Zing::Repo')) {
      $args->{symbol} = $symbols->{'Zing::Repo'};
      $args->{bucket} = $item->name;
    }
    else {
      Carp::confess qq(Error in term: Unrecognizable "object");
    }
    $args->{target} = ($item->env->target || 'global');
    $args->{handle} = ($item->env->handle || 'main');
    $args->{system} = 'zing';
  }
  elsif(defined $item && !ref $item) {
    my $schema = [split /:/, "$item", 5];

    my $system = $schema->[0];
    my $handle = $schema->[1];
    my $target = $schema->[2];
    my $symbol = $schema->[3];
    my $bucket = $schema->[4];

    unless ($system eq 'zing') {
      Carp::confess qq(Error in term: Unrecognizable "system" in: $item);
    }
    unless (grep {$_ eq $symbol} values %$symbols) {
      Carp::confess qq(Error in term: Unrecognizable "symbol" ($symbol) in: $item);
    }

    $args->{system} = $system;
    $args->{handle} = $handle;
    $args->{target} = $target;
    $args->{symbol} = $symbol;
    $args->{bucket} = $bucket;
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

method meta() {
  unless ($self->symbol eq 'meta') {
    Carp::confess 'Error in term: not a "meta" term';
  }

  return $self->string;
}

method object() {
  require Zing::Env;

  my $env = Zing::Env->new(
    handle => $self->handle,
    target => $self->target,
  );

  my $space = Data::Object::Space->new(
    ({reverse %$symbols})->{$self->symbol}
  );

  return $space->build(env => $env, name => $self->bucket);
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

  return lc join ':', $system, $handle, $target, $symbol, $bucket;
}

1;
