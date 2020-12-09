package Zing::Poll;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Time::HiRes ();

# VERSION

# ATTRIBUTES

has 'repo' => (
  is => 'ro',
  isa => 'Repo',
  req => 1,
);

# METHODS

method await(Int $secs) {
  my $data;
  my $repo = $self->repo;
  my @tres = (Time::HiRes::gettimeofday);
  my $time = join('', $tres[0] + $secs, $tres[1]);

  until ($data = $repo->recv) {
    last if join('', Time::HiRes::gettimeofday) >= $time;
  }

  return $data;
}

1;
