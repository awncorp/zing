package Zing::Node;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Socket;
use Sys::Hostname;

# VERSION

# ATTRIBUTES

my ($i, $t) = (0, time);

has 'name' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_name($self) {
  join(':', time, sprintf('%04d', ($i = ($t == time ? $i + 1 : 1))))
}

has 'host' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_host($self) {
  inet_ntoa(scalar(gethostbyname(hostname || 'localhost')))
}

has 'pid' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_pid($self) {
  $$
}

# METHODS

method identifier() {
  return join ':', map $self->$_, qw(host pid name);
}

1;
