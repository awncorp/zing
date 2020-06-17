package Zing::Daemon;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use Config;
use File::Spec;
use POSIX;

# VERSION

# ATTRIBUTES

has 'app' => (
  is => 'ro',
  isa => 'Zing',
  req => 1,
);

has 'name' => (
  is => 'ro',
  isa => 'Str',
  req => 1,
);

has 'log' => (
  is => 'ro',
  isa => 'Logger',
  hnd => [qw(info debug warn fatal)],
  new => 1,
);

fun new_log($self) {
  FlightRecorder->new(level => 'info')
}

has 'pid_dir' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_pid_dir($self) {
  -w File::Spec->curdir ? File::Spec->curdir : File::Spec->tmpdir
}

has 'pid_file' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_pid_file($self) {
  join '.', $self->name, 'pid'
}

has 'pid_path' => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_pid_path($self) {
  File::Spec->catfile($self->pid_dir, $self->pid_file)
}

# METHODS

method execute() {
  my $app = $self->app;
  my $file = $self->pid_path;

  if (-e $file) {
    $self->fatal("pid file exists: $file");
    return 1;
  }

  open(my $fh, ">", "$file") or do {
    $self->fatal("pid file error: $!");
    return 1;
  };

  my ($cnt, $err) = do {
    local $@;
    (eval{chmod(0644, $file)}, $@)
  };
  if ($err) {
    $self->fatal("pid file error: $err");
    return 1;
  }

  # launch app
  my $pid = $self->fork;
  my $name = $self->name;

  print $fh "$pid\n";
  close $fh;

  $self->info("app created: $name");
  $self->info("pid file created: $file");

  return 0;
}

method fork() {
  my $app = $self->app;

  if ($Config{d_pseudofork}) {
    die "Error on fork: fork emulation not supported";
  }

  my $pid = fork;

  if (!defined $pid) {
    die "Error on fork: $!";
  }
  elsif ($pid == 0) {
    $self->app->start; # child
    POSIX::_exit(0);
  }

  return $pid;
}

method start() {
  exit($self->execute);
}

1;
