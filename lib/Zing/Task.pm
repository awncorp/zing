package Zing::Task;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

use FlightRecorder;

extends 'App::Spec::Run::Cmd';

# VERSION

# ATTRIBUTES

has 'log' => (
  is => 'ro',
  isa => 'Logger',
  hnd => [qw(info debug warn fatal)],
  new => 1,
);

fun new_log($self) {
  FlightRecorder->new(auto => undef, level => 'info')
}

method execute() {

  return $self->process;
}

1;
