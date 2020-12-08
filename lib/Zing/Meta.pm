package Zing::Meta;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::KeyVal';

# VERSION

# METHODS

# method clean() {
#   for my $term (@{$self->keys}) {
#     if (my $data = $self->store->recv($term)) {
#       if (my $pid = $data->{process}) {
#         $self->store->drop($term) if !kill 0, $pid;
#       }
#     }
#   }
#   return $self;
# }

method term() {
  return $self->app->term($self)->meta;
}

1;
