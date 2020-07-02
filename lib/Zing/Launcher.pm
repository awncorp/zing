package Zing::Launcher;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::Space;

extends 'Zing::Worker';

# VERSION

# METHODS

method handle(Str $name, HashRef $data) {
  return $self if !$data->{scheme};

  my $class = $data->{scheme}[0];
  my $space = Data::Object::Space->new($class);
  my $build = $space->build(@{$data->{scheme}[1]});

  $build->execute for 1..($data->{scheme}[2] || 1);

  return $self;
}

1;
