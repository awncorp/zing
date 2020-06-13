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

fun new_name($self) {
  inet_ntoa(scalar(gethostbyname(hostname || 'localhost')))
}

1;
