package Zing::Env;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Cwd ();
use Sys::Hostname ();

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

has config => (
  is => 'ro',
  isa => 'HashRef[ArrayRef]',
  new => 1,
);

fun new_config($self) {
  my $config = {};
  for my $KEY (grep /ZING_CONFIG_/, keys %ENV) {
    $config->{lc($KEY =~ s/ZING_CONFIG_//r)} = [
      map +($$_[0], $#{$$_[1]} ? $$_[1] : $$_[1][0]),
      map [$$_[0], [split /\|/, $$_[1]]],
      map [split /=/], split /,\s*/,
      $ENV{$KEY} || ''
    ];
  }
  $config;
}

has debug => (
  is => 'ro',
  isa => 'Maybe[Bool]',
  new => 1,
);

fun new_debug($self) {
  $ENV{ZING_DEBUG}
}

has encoder => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_encoder($self) {
  $ENV{ZING_ENCODER} || 'Zing::Encoder::Dump'
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
  $ENV{ZING_HOST} || Sys::Hostname::hostname
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
  $ENV{ZING_STORE} || 'Zing::Store::Hash'
}

has target => (
  is => 'ro',
  isa => 'Maybe[Name]',
  new => 1,
);

fun new_target($self) {
  $ENV{ZING_TARGET}
}

1;
