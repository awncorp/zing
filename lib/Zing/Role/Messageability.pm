package Zing::Role::Messageability;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Role;

use Zing::Mailbox;
use Zing::Message;

# VERSION

# METHODS

method message(HashRef $data) {

  return Zing::Message->new(from => $self->name, payload => $data);
}

method notify(Str $name, HashRef $data) {

  return Zing::Mailbox->new(name => $name)->send($self->message($data));
}

1;
