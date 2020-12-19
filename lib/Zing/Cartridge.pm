package Zing::Cartridge;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Entity';

use File::Spec;

# VERSION

# ATTRIBUTES

has appdir => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_appdir($self) {
  $self->env->appdir || $self->env->home || File::Spec->curdir
}

has appfile => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_appfile($self) {
  File::Spec->catfile($self->appdir, $self->name)
}

has libdir => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  new => 1,
);

fun new_libdir($self) {
  ['.']
}

has piddir => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_piddir($self) {
  $self->env->piddir || $self->env->home
}

has pidfile => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_pidfile($self) {
  File::Spec->catfile($self->piddir, "@{[$self->name]}.pid")
}

has name => (
  is => 'ro',
  isa => 'Str',
  opt => 1,
);

has scheme => (
  is => 'rw',
  isa => 'Scheme',
  new => 1,
);

fun new_scheme($self) {
  my %seen = map {$_, 1} @INC;
  for my $dir (@{$self->libdir}) {
    push @INC, $dir if !$seen{$dir}++;
  }
  local $@; eval {
    do $self->appfile
  }
}

# METHODS

method pid() {
  local $@; return eval {
    do $self->pidfile
  }
}

method install(Scheme $scheme = $self->scheme) {
  require Data::Dumper;

  no warnings 'once';

  local $Data::Dumper::Indent = 0;
  local $Data::Dumper::Purity = 0;
  local $Data::Dumper::Quotekeys = 0;
  local $Data::Dumper::Deepcopy = 1;
  local $Data::Dumper::Deparse = 1;
  local $Data::Dumper::Sortkeys = 1;
  local $Data::Dumper::Terse = 1;
  local $Data::Dumper::Useqq = 1;

  open(my $fh, '>', $self->appfile) or die "Can't create cartridge: $!";
  print $fh Data::Dumper::Dumper($scheme);
  close $fh;

  return $self;
}

1;
