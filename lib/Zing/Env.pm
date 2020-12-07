package Zing::Env;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Cwd ();

# VERSION

# ATTRIBUTES

has app => (
  is => 'ro',
  isa => 'App',
  new => 1,
);

fun new_app($self) {
  require Zing::App; Zing::App->new(env => $self);
}

has appdir => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_appdir($self) {
  $ENV{ZING_APPDIR};
}

has debug => (
  is => 'ro',
  isa => 'Maybe[Bool]',
  new => 1,
);

fun new_debug($self) {
  $ENV{ZING_DEBUG}
}

has handle => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_handle($self) {
  $ENV{ZING_HANDLE} || $ENV{ZING_NS}
}

has home => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_home($self) {
  $ENV{ZING_HOME} || Cwd::getcwd
}

has host => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_host($self) {
  $ENV{ZING_HOST}
}

has piddir => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_piddir($self) {
  $ENV{ZING_PIDDIR}
}

has store => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_store($self) {
  $ENV{ZING_STORE} || 'Zing::Redis'
}

has target => (
  is => 'ro',
  isa => 'Maybe[Enum[qw(global local)]]',
  new => 1,
);

fun new_target($self) {
  $ENV{ZING_TARGET}
}

1;
