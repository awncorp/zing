package Zing::Role::Queueability;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Role;

with 'Zing::Role::Messageability';

use Zing::Queue;

# VERSION

# METHODS

method dequeue(Str $name) {

  return $self->queue($name)->recv;
}

method enqueue(Str $name, HashRef $data) {

  return $self->queue($name)->send($self->message($data));
}

method queue(Str $name) {

  return Zing::Queue->new(name => $name);
}

1;
