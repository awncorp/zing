package Zing::Entity;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Class';

# VERSION

# ATTRIBUTES

has app => (
  is => 'ro',
  isa => 'App',
  new => 1,
);

fun new_app($self) {
  $self->env->app
}

has env => (
  is => 'ro',
  isa => 'Env',
  new => 1,
);

fun new_env($self) {
  require Zing::Env; Zing::Env->new;
}

# BUILDERS

fun BUILD($self, $args) {
  $self->{env} = $self->{app}->env if $self->{app} && !$self->{env};

  return $self;
}

1;
