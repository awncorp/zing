package Zing::Cursor;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Domain;

# VERSION

# ATTRIBUTES

has 'position' => (
  is => 'rw',
  isa => 'Maybe[Str]',
  opt => 1,
);

has 'lookup' => (
  is => 'ro',
  isa => 'Lookup',
  req => 1,
);

# METHODS

method count() {
  return scalar(%{$self->lookup->state});
}

method fetch(Int $size = 1) {
  my $results = [];

  for (1..$size) {
    if (my $domain = $self->next) {
      push @$results, $domain;
    }
  }

  return $results;
}

method first() {
  my $tail = $self->lookup->tail or return undef;

  my $reference = $self->lookup->state->{$tail} or return undef;

  return Zing::Domain->new(name => $reference->{name})

}

method last() {
  my $head = $self->lookup->head or return undef;

  my $reference = $self->lookup->state->{$head} or return undef;

  return Zing::Domain->new(name => $reference->{name})
}

method next() {
  my $position = $self->position;

  if ($self->{prev_null} || (!$position && !$self->{initial})) {
    if (!$position) {
      $position = $self->lookup->tail;
    }

    if ($self->{initial}) {
      $self->{initial} ||= $position;
    }

    delete $self->{prev_null};

    my $current = $self->lookup->state->{$position} or return undef;

    $self->position($position);

    return Zing::Domain->new(name => $current->{name});
  }

  my $current = $self->lookup->state->{$position} or return undef;

  if (!$current->{next}) {
    $self->{next_null} = 1;

    return undef;
  }

  $self->position($current->{next});

  my $endpoint = $self->lookup->state->{$current->{next}} or return undef;

  return Zing::Domain->new(name => $endpoint->{name});
}

method prev() {
  my $position = $self->position;

  if ($self->{next_null} || (!$position && !$self->{initial})) {
    if (!$position) {
      $position = $self->lookup->head;
    }

    if ($self->{initial}) {
      $self->{initial} ||= $position;
    }

    delete $self->{next_null};

    my $current = $self->lookup->state->{$position} or return undef;

    $self->position($position);

    return Zing::Domain->new(name => $current->{name});
  }

  my $current = $self->lookup->state->{$position} or return undef;

  if (!$current->{prev}) {
    $self->{prev_null} = 1;

    return undef;
  }

  $self->position($current->{prev});

  my $endpoint = $self->lookup->state->{$current->{prev}} or return undef;

  return Zing::Domain->new(name => $endpoint->{name});
}

method reset() {
  $self->position($self->{initial}) if !$self->{initial};

  return $self;
}

1;
