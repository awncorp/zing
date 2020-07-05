package Zing::Cli;

use 5.014;

use strict;
use warnings;

use lib '.';

use parent 'Data::Object::Cli';

use Zing;
use Zing::Channel;
use Zing::Daemon;
use Zing::Registry;

use FlightRecorder;
use File::Spec;

# VERSION

our $name = 'zing <{command}> [<{app}>] [options]';

# METHODS

sub auto {
  {
    clean => '_handle_clean',
    logs => '_handle_logs',
    pid => '_handle_pid',
    restart => '_handle_restart',
    update => '_handle_update',
    start => '_handle_start',
    stop => '_handle_stop',
  }
}

sub subs {
  {
    clean => 'Prune the process registry',
    logs => 'Tap logs and output to STDOUT',
    pid => 'Display an application process ID',
    restart => 'Restart the specified application',
    update => 'Hot-reload application processes',
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
    backlog => {
      desc => 'Produce log output using the backlog',
      type => 'flag',
      flag => 'b',
    },
    global => {
      desc => 'Tap the "global" log channel (defaults to "local")',
      type => 'flag',
      flag => 'g',
    },
    process => {
      desc => 'Reduce log output by process name',
      type => 'string',
      flag => 'p',
    },
    level => {
      desc => 'Reduce log output by log-level',
      type => 'string',
      flag => 'l',
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
    search => {
      desc => 'Reduce log output by search string',
      type => 'string',
      flag => 's',
      args => '@',
    },
    tag => {
      desc => 'Reduce log output by process tag',
      type => 'string',
      flag => 't',
    },
    verbose => {
      desc => 'Produce verbose log output',
      type => 'flag',
      flag => 'v',
    },
  }
}

sub _handle_clean {
  my ($self) = @_;

  my $r = Zing::Registry->new;

  for my $id (@{$r->ids}) {
    my $data = $r->store->recv($id) or next;
    my $pid = $data->{process} or next;
    $r->store->drop($id) unless kill 0, $pid;
  }

  return $self;
}

sub _handle_logs {
  my ($self) = @_;

  my $c = Zing::Channel->new(
    name => '$journal',
    (target => $self->opts->global ? 'global' : 'local')
  );

  $c->reset if $self->opts->backlog;

  while (1) {
    next unless my $info = $c->recv;

    my $from = $info->{from};
    my $data = $info->{data};
    my $logs = $data->{logs};

    $logs->{level} = $self->opts->level if $self->opts->level;

    my $logger = FlightRecorder->new($logs);
    my $report = $self->opts->verbose ? 'verbose' : 'simple';
    my $lines = $logger->$report->lines;
    my $tag = $data->{tag} || '--';

    if (my $filter = $self->opts->from) {
      next unless $from =~ /$filter/;
    }

    if (my $filter = $self->opts->tag) {
      next unless $tag =~ /$filter/;
    }

    if (my $search = $self->opts->search) {
      for my $search (@$search) {
        @$lines = grep /$search/, @$lines;
      }
    }

    print STDOUT $from, ' ', $tag, ' ', $_, "\n" for @$lines;
  }

  return $self;
}

sub _handle_pid {
  my ($self) = @_;

  my $app = $self->args->app;

  if (!$app) {
    print $self->help, "\n";
    return $self->okay;
  }

  my $piddir = $self->opts->piddir
    || $ENV{ZING_PIDDIR}
    || $ENV{ZING_HOME}
    || File::Spec->curdir;

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

  print "Process ID: $pid\n";

  return $self;
}

sub _handle_restart {
  my ($self) = @_;

  $self->_handle_stop;
  $self->_handle_start;

  return $self;
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

  $appdir ||= $ENV{ZING_APPDIR} || $ENV{ZING_HOME} || File::Spec->curdir;

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

  return $self;
}

sub _handle_stop {
  my ($self) = @_;

  my $app = $self->args->app;

  if (!$app) {
    print $self->help, "\n";
    return $self->okay;
  }

  my $piddir = $self->opts->piddir
    || $ENV{ZING_PIDDIR}
    || $ENV{ZING_HOME}
    || File::Spec->curdir;

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

  return $self;
}

sub _handle_update {
  my ($self) = @_;

  my $app = $self->args->app;

  if (!$app) {
    print $self->help, "\n";
    return $self->okay;
  }

  my $piddir = $self->opts->piddir
    || $ENV{ZING_PIDDIR}
    || $ENV{ZING_HOME}
    || File::Spec->curdir;

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

  kill 'USR2', $pid;

  return $self;
}

1;

__DATA__

zing - multi-process management system

Usage: {name}

Commands:

{commands}

Options:

{options}
