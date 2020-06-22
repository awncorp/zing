package Zing::Cli;

use 5.014;

use strict;
use warnings;

use lib '.';

use parent 'Data::Object::Cli';

use Zing;
use Zing::Channel;
use Zing::Daemon;

use FlightRecorder;
use File::Spec;

# VERSION

our $name = 'zing <{command}> <{app}> [options]';

# METHODS

sub auto {
  {
    logs => '_handle_logs',
    start => '_handle_start',
    stop => '_handle_stop',
  }
}

sub subs {
  {
    logs => 'Tap logs and output to STDOUT',
    start => 'Start the specified application',
    stop => 'Stop the specified application',
  }
}

sub spec {
  {
    appdir => {
      desc => 'Directory of the app file',
      type => 'string',
      flag => 'a',
    },
    libdir => {
      desc => 'Directory for @INC',
      type => 'string',
      flag => 'I',
      args => '@',
    },
    piddir => {
      desc => 'Directory for the pid file',
      type => 'string',
      flag => 'd',
    },
  }
}

sub _handle_logs {
  my ($self) = @_;

  my $c = Zing::Channel->new(name => 'journal');

  while (1) {
    next unless my $info = $c->recv;

    my $from = $info->{from};
    my $data = $info->{data};

    my $logger = FlightRecorder->new($data);

    if (my $lines = $logger->simple->generate) {
      print STDOUT $from, ' ', $lines, "\n";
    }
  }

  $self->okay;
}

sub _handle_start {
  my ($self) = @_;

  my $app = $self->args->app;

  if (!$app) {
    print $self->help, "\n";
    return $self->okay;
  }

  my $appdir = $self->opts->appdir;
  my $piddir = $self->opts->piddir;
  my $libdir = $self->opts->libdir;

  unshift @INC, @$libdir if $libdir;

  $appdir ||= File::Spec->curdir;

  my $appfile = File::Spec->catfile($appdir, $app);

  if (! -e $appfile) {
    print "Can't find app: $appfile\n";
    return $self->fail;
  }

  my $scheme = do { local $@; eval { do $appfile } };

  if (ref $scheme ne 'ARRAY') {
    print "File didn't return an app scheme: $appfile\n";
    return $self->fail;
  }

  my $daemon = Zing::Daemon->new(
    name => $app,
    app => Zing->new(scheme => $scheme),
    ($piddir ? (pid_dir => $piddir) : ()),
  );

  $daemon->start;
}

sub _handle_stop {
  my ($self) = @_;

  my $app = $self->args->app;

  if (!$app) {
    print $self->help, "\n";
    return $self->okay;
  }

  my $piddir = $self->opts->piddir;
  my $libdir = $self->opts->libdir;

  unshift @INC, @$libdir if $libdir;

  $piddir ||= File::Spec->curdir;

  my $pidfile = File::Spec->catfile($piddir, "$app.pid");

  if (! -e $pidfile) {
    print "Can't find pid $pidfile\n";
    return $self->fail;
  }

  my $pid = do { local $@; eval { do $pidfile } };

  if (!$pid || ref $pid) {
    print "File didn't return a process ID: $pidfile\n";
    return $self->fail;
  }

  kill 'TERM', $pid;

  unlink $pidfile;

  $self->okay;
}

1;

__DATA__

zing - multi-process management system

Usage: {name}

Commands:

{commands}

Options:

{options}
