package Zing::Term;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

extends 'Zing::Class';

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
  'Zing::Table'    => 'table',
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
    elsif ($item->isa('Zing::Table')) {
      $args->{symbol} = $symbols->{'Zing::Table'};
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
      $self->throw(error_term_unknow_object($item));
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
      $self->throw(error_term_unknow_system("$item"));
    }
    unless (grep {$_ eq $symbol} values %$symbols) {
      $self->throw(error_term_unknow_symbol("$item"));
    }

    $args->{system} = $system;
    $args->{handle} = $handle;
    $args->{target} = $target;
    $args->{symbol} = $symbol;
    $args->{bucket} = $bucket;
  }
  else {
    $self->throw(error_term_unknown());
  }

  return $args;
}

# METHODS

method channel() {
  unless ($self->symbol eq 'channel') {
    $self->throw(error_term_invalid("channel"));
  }

  return $self->string;
}

method data() {
  unless ($self->symbol eq 'data') {
    $self->throw(error_term_invalid("data"));
  }

  return $self->string;
}

method domain() {
  unless ($self->symbol eq 'domain') {
    $self->throw(error_term_invalid("domain"));
  }

  return $self->string;
}

method kernel() {
  unless ($self->symbol eq 'kernel') {
    $self->throw(error_term_invalid("kernel"));
  }

  return $self->string;
}

method keyval() {
  unless ($self->symbol eq 'keyval') {
    $self->throw(error_term_invalid("keyval"));
  }

  return $self->string;
}

method lookup() {
  unless ($self->symbol eq 'lookup') {
    $self->throw(error_term_invalid("lookup"));
  }

  return $self->string;
}

method mailbox() {
  unless ($self->symbol eq 'mailbox') {
    $self->throw(error_term_invalid("mailbox"));
  }

  return $self->string;
}

method meta() {
  unless ($self->symbol eq 'meta') {
    $self->throw(error_term_invalid("meta"));
  }

  return $self->string;
}

method object(Maybe[Env] $env) {
  require Zing::Env;

  $env = Zing::Env->new(
    ($env ? %{$env} : ()),
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
    $self->throw(error_term_invalid("process"));
  }

  return $self->string;
}

method pubsub() {
  unless ($self->symbol eq 'pubsub') {
    $self->throw(error_term_invalid("pubsub"));
  }

  return $self->string;
}

method queue() {
  unless ($self->symbol eq 'queue') {
    $self->throw(error_term_invalid("queue"));
  }

  return $self->string;
}

method repo() {
  unless ($self->symbol eq 'repo') {
    $self->throw(error_term_invalid('repo'));
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

method table() {
  unless ($self->symbol eq 'table') {
    $self->throw(error_term_invalid('table'));
  }

  return $self->string;
}

# ERRORS

fun error_term_invalid(Str $name) {
  code => 'error_term_invalid',
  message => qq(Error in term: not a "$name" term),
}

fun error_term_unknown() {
  code => 'error_term_unknown',
  message => qq(Unrecognizable term (or object) provided),
}

fun error_term_unknow_object(Object $item) {
  code => 'error_term_unknow_object',
  message => qq(Error in term: Unrecognizable "object": $item),
}

fun error_term_unknow_symbol(Str $term) {
  code => 'error_term_unknow_symbol',
  message => qq(Error in term: Unrecognizable "symbol" in: $term),
}

fun error_term_unknow_system(Str $term) {
  code => 'error_term_unknow_system',
  message => qq(Error in term: Unrecognizable "system" in: $term),
}

1;
