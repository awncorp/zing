package Zing::Daemon;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Entity';

use Carp ();

use Config;
use File::Spec;
use FlightRecorder;
use POSIX;

# VERSION

# ATTRIBUTES

has cartridge => (
  is => 'ro',
  isa => 'Cartridge',
  req => 1,
);

has logger => (
  is => 'ro',
  isa => 'Logger',
  new => 1,
);

fun new_logger($self) {
  $self->app->logger
}

has journal => (
  is => 'ro',
  isa => 'Journal',
  new => 1,
);

fun new_journal($self) {
  $self->app->journal(
    level => $self->log_level,
    verbose => $self->log_verbose,
  )
}

has kernel => (
  is => 'ro',
  isa => 'Zing',
  new => 1,
);

fun new_kernel($self) {
  $self->app->zing(scheme => $self->cartridge->scheme)
}

has log_filter_from => (
  is => 'ro',
  isa => 'Str',
  opt => 1,
);

has log_filter_queries => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  opt => 1,
);

has log_filter_tag => (
  is => 'ro',
  isa => 'Str',
  opt => 1,
);

has log_level => (
  is => 'ro',
  isa => 'Str',
  def => 'debug',
);

has log_reset => (
  is => 'ro',
  isa => 'Bool',
  def => 0,
);

has log_verbose => (
  is => 'ro',
  isa => 'Bool',
  def => 0,
);

# METHODS

method fork() {
  if ($Config{d_pseudofork}) {
    Carp::confess "Error on fork: fork emulation not supported";
  }

  my $pid = fork;

  if (!defined $pid) {
    Carp::confess "Error on fork: $!";
  }
  elsif ($pid == 0) {
    Carp::confess "Error in fork: terminal detach failed" if POSIX::setsid() < 0;
    $self->kernel->start; # child
    unlink $self->cartridge->pidfile;
    POSIX::_exit(0);
  }

  return $pid;
}

method logs(CodeRef $callback) {
  my $journal = $self->journal;

  if ($self->log_reset) {
    $journal->reset;
  }

  $journal->stream(fun ($info, $data, $lines) {
    my $cont = 1;

    my $from = $info->{from};
    my $tag = $info->{data}{tag} || '--';

    if (my $filter = $self->log_filter_from) {
      $cont = 0 unless $from =~ /$filter/;
    }

    if (my $filter = $self->log_filter_tag) {
      $cont = 0 unless $tag =~ /$filter/;
    }

    if (my $queries = $self->log_filter_queries) {
      for my $query (@$queries) {
        @$lines = grep /$query/, @$lines;
      }
    }

    if ($cont) {
      for my $line (@$lines) {
        $callback->(join ' ', $from, ' ', $tag, ' ', $line);
      }
    }
  });

  return 1;
}

method restart() {
  return $self->stop && $self->start;
}

method start() {
  my $logger = $self->logger;
  my $cartridge = $self->cartridge;
  my $file = $cartridge->pidfile;

  if (-e $file) {
    $logger->fatal("pid file exists: $file");
    return 0;
  }

  open(my $fh, ">", "$file") or do {
    $logger->fatal("pid file error: $!");
    return 0;
  };

  my ($cnt, $err) = do {
    local $@;
    (eval{chmod(0644, $file)}, $@)
  };
  if ($err) {
    $logger->fatal("pid file error: $err");
    return 0;
  }

  my $pid = $self->fork;
  my $name = $cartridge->name;

  print $fh "$pid\n";
  close $fh;

  $logger->info("app created: $name");
  $logger->info("pid file created: $file");

  return 1;
}

method stop() {
  my $logger = $self->logger;
  my $cartridge = $self->cartridge;
  my $file = $cartridge->pidfile;
  my $pid = $cartridge->pid;

  unlink $file;

  if (!$pid) {
    $logger->warn("no pid in file: $file");
  }
  else {
    kill 'TERM', $pid;
  }

  return 1;
}

method update() {
  my $logger = $self->logger;
  my $cartridge = $self->cartridge;
  my $file = $cartridge->pidfile;
  my $pid = $cartridge->pid;

  if (!$pid) {
    $logger->fatal("no pid in file: $file");
    return 0;
  }
  else {
    kill 'USR2', $pid;
  }

  return 1;
}

1;
