package Zing::Types;

use 5.014;

use strict;
use warnings;

use Data::Object::Types::Keywords;

use base 'Data::Object::Types::Library';

extends 'Types::Standard';

# VERSION

register {
  name => 'Channel',
  parent => 'Object',
  validation => is_instance_of('Zing::Channel'),
};

register {
  name => 'Data',
  parent => 'Object',
  validation => is_instance_of('Zing::Data'),
};

register {
  name => 'Error',
  parent => 'Object',
  validation => is_instance_of('Zing::Error'),
};

register {
  name => 'Flow',
  parent => 'Object',
  validation => is_instance_of('Zing::Flow'),
};

register {
  name => 'Fork',
  parent => 'Object',
  validation => is_instance_of('Zing::Fork'),
};

declare 'Interupt',
  as Enum([qw(CHLD HUP INT QUIT TERM USR1 USR2)]);

register {
  name => 'KeyVal',
  parent => 'Object',
  validation => is_instance_of('Zing::KeyVal'),
};

register {
  name => 'Logic',
  parent => 'Object',
  validation => is_instance_of('Zing::Logic'),
};

register {
  name => 'Loop',
  parent => 'Object',
  validation => is_instance_of('Zing::Loop'),
};

register {
  name => 'Logger',
  parent => 'Object',
  validation => is_capable_of(qw(debug info warn error fatal)),
};

register {
  name => 'Mailbox',
  parent => 'Object',
  validation => is_instance_of('Zing::Mailbox'),
};

register {
  name => 'Message',
  parent => 'Object',
  validation => is_instance_of('Zing::Message'),
};

register {
  name => 'Node',
  parent => 'Object',
  validation => is_instance_of('Zing::Node'),
};

register {
  name => 'Process',
  parent => 'Object',
  validation => is_instance_of('Zing::Process'),
};

register {
  name => 'PubSub',
  parent => 'Object',
  validation => is_instance_of('Zing::PubSub'),
};

register {
  name => 'Queue',
  parent => 'Object',
  validation => is_instance_of('Zing::Queue'),
};

register {
  name => 'Registry',
  parent => 'Object',
  validation => is_instance_of('Zing::Registry'),
};

register {
  name => 'Redis',
  parent => 'Object',
  validation => is_instance_of('Redis'),
};

register {
  name => 'Repo',
  parent => 'Object',
  validation => is_instance_of('Zing::Repo'),
};

declare 'Scheme',
  as Tuple([Str(), ArrayRef(), Int()]);

register {
  name => 'Server',
  parent => 'Object',
  validation => is_instance_of('Zing::Server'),
};

register {
  name => 'Space',
  parent => 'Object',
  validation => is_instance_of('Data::Object::Space'),
};

register {
  name => 'Store',
  parent => 'Object',
  validation => is_instance_of('Zing::Store'),
};

register {
  name => 'Task',
  parent => 'Object',
  validation => is_instance_of('Zing::Task'),
};

register {
  name => 'Watcher',
  parent => 'Object',
  validation => is_instance_of('Zing::Watcher'),
};

register {
  name => 'Worker',
  parent => 'Object',
  validation => is_instance_of('Zing::Worker'),
};

1;