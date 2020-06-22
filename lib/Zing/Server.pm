package Zing::Server;

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
  new => 1,
);

state $local = $ENV{ZING_HOST} || '0.0.0.0';

fun new_name($self) {
  state $host = gethostbyname(hostname || 'localhost') if !$ENV{ZING_HOST};
  $host ? inet_ntoa($host) : $local
}

1;
