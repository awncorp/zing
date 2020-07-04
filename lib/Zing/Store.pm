package Zing::Store;

use 5.014;

use strict;
use warnings;

use registry;
use routines;

use Data::Object::Class;

use Carp ();

# VERSION

# METHODS

sub args {
  [
  map +($$_[0], $#{$$_[1]} ? $$_[1] : $$_[1][0]),
  map [$$_[0], [split /\|/, $$_[1]]],
  map [split /=/], split /,\s*/,
  $_[1] || ''
  ]
}

sub drop {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "drop" not implemented);
}

sub dump {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "dump" not implemented);
}

sub keys {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "keys" not implemented);
}

sub pop {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "pop" not implemented);
}

sub pull {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "pull" not implemented);
}

sub push {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "push" not implemented);
}

sub load {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "load" not implemented);
}

sub recv {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "recv" not implemented);
}

sub send {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "send" not implemented);
}

sub size {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "size" not implemented);
}

sub slot {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "slot" not implemented);
}

sub term {
  shift; return join(':', @_);
}


sub test {
  Carp::croak qq(Error in Store: (@{[ref$_[0]]}) method "test" not implemented);
}

1;
