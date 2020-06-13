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

has 'name' => (
  is => 'ro',
  isa => 'Str',
  def => time,
);

has 'host' => (
  is => 'ro',
  isa => 'Str',
  def => inet_ntoa(scalar(gethostbyname(hostname || 'localhost'))),
);

has 'pid' => (
  is => 'ro',
  isa => 'Str',
  def => $$,
);

# METHODS

method identifier() {
  return join ':', map $self->$_, qw(host pid name);
}

1;
