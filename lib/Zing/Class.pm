package Zing::Class;

use 5.014;

use strict;
use warnings;

use registry;
use routines;

use Data::Object::Class;

# VERSION

# METHODS

method throw(@args) {
  require Zing::Error;
  die Zing::Error->new(@args, context => $self)->trace(1);
}

method try($method, @args) {
  require Data::Object::Try;
  my $try = Data::Object::Try->new(invocant => $self, arguments => [@args]);
  return $try->call($try->callback($self->can($method)));
}

1;
