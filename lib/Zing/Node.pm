package Zing::Node;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Zing::Server;

# VERSION

# ATTRIBUTES

my ($i, $t) = (0, time);

has 'name' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_name($self) {
  my $name = join(':', time, sprintf('%04d', ($i = ($t == time ? $i + 1 : 1))));

  # reset iota
  $t = time;

  $name
}

has 'pid' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_pid($self) {
  $$
}

has 'server' => (
  is => 'ro',
  isa => 'Server',
  new => 1,
);

fun new_server($self) {
  Zing::Server->new
}

# METHODS

method identifier() {

  return join ':', $self->server->name, $self->pid, $self->name;
}

1;
