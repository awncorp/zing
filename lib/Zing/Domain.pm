package Zing::Domain;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Channel;

# VERSION

# ATTRIBUTES

has 'name' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'channel' => (
  is => 'ro',
  isa => 'Channel',
  new => 1,
);

fun new_channel($self) {
  Zing::Channel->new(name => $self->name)
}

# BUILDERS

fun BUILD($self) {
  return $self->apply if $self->channel->reset;
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
  undef $self->{data} if $self->channel->renew;

  while (my $data = $self->recv) {
    my $op = $data->{op};
    my $key = $data->{key};
    my $val = $data->{val};

    if ($data->{snapshot} && !$self->{data}) {
      $self->{data} = _copy($data->{snapshot});
    }

    local $@;

    if ($op eq 'decr') {
      eval{($self->data->{$key} //= 0) -= ($val->[0] // 0)};
    }
    elsif ($op eq 'del') {
      eval{CORE::delete $self->data->{$key}};
    }
    elsif ($op eq 'incr') {
      eval{($self->data->{$key} //= 0 ) += ($val->[0] // 0)};
    }
    elsif ($op eq 'pop') {
      eval{CORE::pop @{$self->data->{$key}}};
    }
    elsif ($op eq 'push') {
      eval{CORE::push @{$self->data->{$key}}, @$val};
    }
    elsif ($op eq 'set') {
      eval{$self->data->{$key} = $val->[0]};
    }
    elsif ($op eq 'shift') {
      eval{CORE::shift @{$self->data->{$key}}};
    }
    elsif ($op eq 'unshift') {
      eval{CORE::unshift @{$self->data->{$key}}, @$val};
    }
  }

  return $self;
}

method change(Str $op, Str $key, Any @val) {
  my %fields = (
    key => $key,
    snapshot => _copy($self->data),
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

method data() {
  return $self->{data} ||= {};
}

method get(Str $key) {
  return $self->apply->data->{$key};
}

method decr(Str $key, Int $val = 1) {
  return $self->apply->change('decr', $key, $val);
}

method del(Str $key) {
  return $self->apply->change('del', $key);
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

method recv() {
  return $self->channel->recv;
}

method send(HashRef $data) {
  return $self->channel->send($data);
}

method set(Str $key, Any $val) {
  return $self->apply->change('set', $key, $val);
}

method shift(Str $key) {
  return $self->apply->change('shift', $key);
}

method unshift(Str $key, Any @val) {
  return $self->apply->change('unshift', $key, @val);
}

1;
