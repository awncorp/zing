package Zing::ID;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Sys::Hostname ();

use overload (
  '""'     => 'string',
  fallback => 1
);

# VERSION

# ATTRIBUTES

has host => (
  is => 'ro',
  isa => 'Str',
  init_arg => undef,
  new => 1,
);

fun new_host($self) {
  Sys::Hostname::hostname
}

has iota => (
  is => 'ro',
  isa => 'Int',
  init_arg => undef,
  new => 1,
);

my ($i, $t, $x) = (0, time);

fun new_iota($self) {
  $x = sprintf('%04d', ($i = ($t == time ? $i + 1 : 1)));
  $t = time; # reset
  $x
}

has pid => (
  is => 'ro',
  isa => 'Int',
  init_arg => undef,
  new => 1,
);

fun new_pid($self) {
  $$
}

has salt => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_salt($self) {
  rand
}

has time => (
  is => 'ro',
  isa => 'Int',
  init_arg => undef,
  new => 1,
);

fun new_time($self) {
  time
}

# METHODS

method string() {
  require Digest::SHA; return Digest::SHA::sha1_hex(
    join('-', map $self->$_, qw(host pid time iota salt))
  );
}

1;
