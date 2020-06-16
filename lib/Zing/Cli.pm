package Zing::Cli;

use 5.014;

use strict;
use warnings;

use registry;
use routines;

use Data::Object::Class;

extends 'App::Spec::Run::Cmd';

# VERSION

# BUILD

sub data {
  my ($self) = @_;

  my $space = $self->space;

  $space->data;
}

sub space {
  require Data::Object::Space;

  return Data::Object::Space->new(ref $_[0] || $_[0]);
}

# METHODS

method init($run) {
  require Zing::Task::Init;

  my $task = Zing::Task::Init->new;

  return $task->execute;
}

1;

__DATA__

name: zing

title: |
  multi-process management system

abstract: |

  @@@@@@@@  @@@  @@@@  @@  @@@@@@@@@
       @@!  @@!  @@!@! @@  !@@
      !@!   !@!  !@!!@!@!  !@!
     @!!    !!@  @!@ !!@!  !@! @!@!@
    !!!     !!!  !@!  !!!  !!! !!@!!
   :!:      :!:  :!:  !:!  :!:   !::
  ::: ::::  :!:  :::   ::  :::: ::::

class: Zing

plugins:
- -Format
- -Meta

subcommands:
  init:
    op: init
    summary: Initialize workspace
