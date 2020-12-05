package Zing::Cli;

use 5.014;

use strict;
use warnings;

use feature 'say';

use lib '.';

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Data::Object::Cli';

with 'Zing::Context';

# VERSION

# ATTRIBUTES

has arg_app => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_arg_app($self) {
  $self->args->app
}

has cartridge => (
  is => 'ro',
  isa => 'Cartridge',
  new => 1,
);

fun new_cartridge($self) {
  $self->env->app->cartridge(
    name => $self->arg_app,
    $self->opt_appdir ? (appdir => $self->opt_appdir) : (),
    $self->opt_libdir ? (libdir => $self->opt_libdir) : (),
    $self->opt_piddir ? (piddir => $self->opt_piddir) : (),
  )
}

has daemon => (
  is => 'ro',
  isa => 'Daemon',
  new => 1,
);

fun new_daemon($self) {
  $self->env->app->daemon(
    cartridge => $self->cartridge,
    $self->opt_backlog ? (log_reset => $self->opt_backlog) : (),
    $self->opt_level ? (log_level => $self->opt_level) : (),
    $self->opt_process ? (log_filter_from => $self->opt_process) : (),
    $self->opt_search ? (log_filter_queries => $self->$self->opt_search) : (),
    $self->opt_tag ? (log_filter_tag => $self->opt_tag) : (),
    $self->opt_verbose ? (log_verbose => $self->opt_verbose) : (),
  )
}

has opt_appdir => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_opt_appdir($self) {
  $self->opts->appdir
}

has opt_backlog => (
  is => 'ro',
  isa => 'Maybe[Bool]',
  new => 1,
);

fun new_opt_backlog($self) {
  $self->opts->backlog
}

has opt_global => (
  is => 'ro',
  isa => 'Maybe[Bool]',
  new => 1,
);

fun new_opt_global($self) {
  $self->opts->global
}

has opt_handle => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_opt_handle($self) {
  $self->opts->handle
}

has opt_level => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_opt_level($self) {
  $self->opts->level
}

has opt_libdir => (
  is => 'ro',
  isa => 'Maybe[ArrayRef[Str]]',
  new => 1,
);

fun new_opt_libdir($self) {
  $self->opts->libdir
}

has opt_package => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_opt_package($self) {
  $self->opts->package
}

has opt_piddir => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_opt_piddir($self) {
  $self->opts->piddir
}

has opt_process => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_opt_process($self) {
  $self->opts->process
}

has opt_search => (
  is => 'ro',
  isa => 'Maybe[ArrayRef[Str]]',
  new => 1,
);

fun new_opt_search($self) {
  $self->opts->search
}

has opt_tag => (
  is => 'ro',
  isa => 'Maybe[Str]',
  new => 1,
);

fun new_opt_tag($self) {
  $self->opts->tag
}

has opt_verbose => (
  is => 'ro',
  isa => 'Maybe[Bool]',
  new => 1,
);

fun new_opt_verbose($self) {
  $self->opts->verbose
}

has registry => (
  is => 'ro',
  isa => 'Registry',
  new => 1,
);

fun new_registry($self) {
  $self->env->app->registry
}

# USAGE

our $name = 'zing <{command}> [<{app}>] [options]';

# CONFIGURATION

fun auto() {
  {
    clean => 'handle_clean',
    install => 'handle_install',
    logs => 'handle_logs',
    monitor => 'handle_monitor',
    pid => 'handle_pid',
    restart => 'handle_restart',
    start => 'handle_start',
    stop => 'handle_stop',
    terms => 'handle_terms',
    update => 'handle_update',
  }
}

fun subs() {
  {
    clean => 'Prune the process registry',
    install => 'Create an application cartridge',
    logs => 'Tap logs and output to STDOUT',
    monitor => 'Monitor the specified application (start if not started)',
    pid => 'Display an application process ID',
    restart => 'Restart the specified application',
    start => 'Start the specified application',
    stop => 'Stop the specified application',
    terms => 'Display resource identifiers (under specified namespace)',
    update => 'Hot-reload application processes',
  }
}

fun spec() {
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
    handle => {
      desc => 'Provide a handle (namespace)',
      type => 'string',
      flag => 'h',
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
    package => {
      desc => 'Provide a process package name',
      type => 'string',
      flag => 'P',
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

# METHODS

method handle_clean() {
  $self->registry->clean;
  $self->output('registry cleaned');
  exit(0);
}

method handle_install() {
  if (!$self->arg_app) {
    $self->output('error: app required');
    exit(1);
  }
  if (!$self->opt_package) {
    $self->output('error: package required');
    exit(1);
  }
  else {
    my $space = Data::Object::Space->new($self->opt_package);
    my %seen = map {$_, 1} @INC;
    for my $dir (@{$self->opt_libdir}) {
      push @INC, $dir if !$seen{$dir}++;
    }
    if (!$space->load->can('install')) {
      $self->output('error: uninstallable');
      exit(1);
    }
    else {
      $self->output('installing ...');
      $self->cartridge->install($space->build->install);
      exit(0);
    }
  }
}

method handle_logs() {
  if (!$self->arg_app) {
    $self->output('error: app required');
    exit(1);
  }
  else {
    $self->daemon->logs(fun($line) {
      $self->output($line);
    });
    exit(0);
  }
}

method handle_monitor() {
  if (!$self->arg_app) {
    $self->output('error: app required');
    exit(1);
  }
  else {
    $self->output('monitoring ...');
  }
  if (!-e $self->cartridge->pidfile) {
    $self->daemon->start;
  }
  $self->handle_logs;
  exit(0);
}

method handle_pid() {
  if (!$self->arg_app) {
    $self->output('error: app required');
    exit(1);
  }
  else {
    if (my $pid = $self->cartridge->pid) {
      $self->output($pid);
      exit(0);
    }
    else {
      $self->output('error: no pid');
      exit(1);
    }
  }
}

method handle_restart() {
  if (!$self->arg_app) {
    $self->output('error: app required');
    exit(1);
  }
  elsif (!-f $self->cartridge->appfile) {
    $self->output('error: app not found');
    exit(1);
  }
  else {
    $self->output('restarting ...');
  }
  exit(!$self->daemon->restart);
}

method handle_start() {
  if (!$self->arg_app) {
    $self->output('error: app required');
    exit(1);
  }
  elsif (!-f $self->cartridge->appfile) {
    $self->output('error: app not found');
    exit(1);
  }
  else {
    $self->output('starting ...');
  }
  exit(!$self->daemon->start);
}

method handle_stop() {
  if (!$self->arg_app) {
    $self->output('error: app required');
    exit(1);
  }
  elsif (!-f $self->cartridge->appfile) {
    $self->output('error: app not found');
    exit(1);
  }
  else {
    $self->output('stopping ...');
  }
  exit(!$self->daemon->stop);
}

method handle_terms() {
  $self->output(@{$self->registry->terms});
  exit(0);
}

method handle_update() {
  if (!$self->arg_app) {
    $self->output('error: app required');
    exit(1);
  }
  elsif (!-f $self->cartridge->appfile) {
    $self->output('error: app not found');
    exit(1);
  }
  else {
    $self->output('updating ...');
  }
  exit(!$self->daemon->update);
}

method output(Str @args) {
  say $_ for @args; return $self;
}

1;

__DATA__

zing - multi-process management system

Usage: {name}

Commands:

{commands}

Options:

{options}
