package Zing::Domain;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Channel';

use Zing::Term;

use Scalar::Util ();

# VERSION

# ATTRIBUTES

has 'metadata' => (
  is => 'ro',
  isa => 'HashRef',
  new => 1,
);

fun new_metadata($self) {
  {}
}

# BUILDERS

fun BUILD($self) {
  $self->{cursor}-- if $self->{cursor};

  return $self->apply;
}

# SHIMS

sub _copy {
  my ($data) = @_;

  if (!defined $data) {
    return undef;
  }
  elsif (ref $data eq 'ARRAY') {
    my $copy = [];
    for (my $i = 0; $i < @$data; $i++) {
      $copy->[$i] = _copy($data->[$i]);
    }
    return $copy;
  }
  elsif (ref $data eq 'HASH') {
    my $copy = {};
    for my $key (keys %$data) {
      $copy->{$key} = _copy($data->{$key});
    }
    return $copy;
  }
  else {
    return $data;
  }
}

# METHODS

method apply() {
  undef $self->{state} if $self->renew;

  while (my $data = $self->recv) {
    my $op = $data->{op};
    my $key = $data->{key};
    my $val = $data->{val};

    if ($data->{snapshot} && !$self->{state}) {
      $self->{state} = _copy($data->{snapshot});
    }

    local $@;

    if ($op eq 'decr') {
      eval{($self->state->{$key} //= 0) -= ($val->[0] // 0)};
    }
    elsif ($op eq 'del') {
      eval{CORE::delete $self->state->{$key}};
    }
    elsif ($op eq 'incr') {
      eval{($self->state->{$key} //= 0 ) += ($val->[0] // 0)};
    }
    elsif ($op eq 'pop') {
      eval{CORE::pop @{$self->state->{$key}}};
    }
    elsif ($op eq 'push') {
      eval{CORE::push @{$self->state->{$key}}, @$val};
    }
    elsif ($op eq 'set') {
      eval{$self->state->{$key} = $val->[0]};
    }
    elsif ($op eq 'shift') {
      eval{CORE::shift @{$self->state->{$key}}};
    }
    elsif ($op eq 'unshift') {
      eval{CORE::unshift @{$self->state->{$key}}, @$val};
    }

    $self->emit($key, $data);
  }

  return $self;
}

method change(Str $op, Str $key, Any @val) {
  my %fields = (
    key => $key,
    metadata => $self->metadata,
    snapshot => _copy($self->state),
    time => time,
    val => [@val],
  );

  if ($op eq 'decr') {
    $self->send({ %fields, op => 'decr' });
  }
  elsif ($op eq 'del') {
    $self->send({ %fields, op => 'del' });
  }
  elsif ($op eq 'incr') {
    $self->send({ %fields, op => 'incr' });
  }
  elsif ($op eq 'pop') {
    $self->send({ %fields, op => 'pop' });
  }
  elsif ($op eq 'push') {
    $self->send({ %fields, op => 'push' });
  }
  elsif ($op eq 'set') {
    $self->send({ %fields, op => 'set' });
  }
  elsif ($op eq 'set') {
    $self->send({ %fields, op => 'set' });
  }
  elsif ($op eq 'shift') {
    $self->send({ %fields, op => 'shift' });
  }
  elsif ($op eq 'unshift') {
    $self->send({ %fields, op => 'unshift' });
  }

  return $self->apply;
}

method decr(Str $key, Int $val = 1) {
  return $self->apply->change('decr', $key, $val);
}

method del(Str $key) {
  return $self->apply->change('del', $key);
}

method emit(Str $key, HashRef $event) {
  my $handlers = $self->handlers->{$key};

  return $self if !$handlers;

  for my $handler (@$handlers) {
    $handler->[1]->($self, $event);
  }

  return $self;
}

method get(Str $key) {
  return $self->apply->state->{$key};
}

method handlers() {
  return $self->{handlers} ||= {};
}

method ignore(Str $key, Maybe[CodeRef] $sub) {
  return $self if !$self->handlers->{$key};

  return do { delete $self->handlers->{$key}; $self } if !$sub;

  my $ref = Scalar::Util::refaddr($sub);

  @{$self->handlers->{$key}} = grep {$ref ne $$_[0]} @{$self->handlers->{$key}};

  delete $self->handlers->{$key} if !@{$self->handlers->{$key}};

  return $self;
}

method incr(Str $key, Int $val = 1) {
  return $self->apply->change('incr', $key, $val);
}

method pop(Str $key) {
  return $self->apply->change('pop', $key);
}

method push(Str $key, Any @val) {
  return $self->apply->change('push', $key, @val);
}

method set(Str $key, Any $val) {
  return $self->apply->change('set', $key, $val);
}

method shift(Str $key) {
  return $self->apply->change('shift', $key);
}

method state() {
  return $self->{state} ||= {};
}

method listen(Str $key, CodeRef $sub) {
  my $ref = Scalar::Util::refaddr($sub);

  push @{$self->ignore($key, $sub)->handlers->{$key}}, [$ref, $sub];

  return $self;
}

method term() {
  return Zing::Term->new($self)->domain;
}

method unshift(Str $key, Any @val) {
  return $self->apply->change('unshift', $key, @val);
}

1;
