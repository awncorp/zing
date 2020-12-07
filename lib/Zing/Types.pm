package Zing::Types;

use 5.014;

use strict;
use warnings;

use Data::Object::Types::Keywords;

use base 'Data::Object::Types::Library';

extends 'Types::Standard';

# VERSION

register {
  name => 'App',
  parent => 'Object',
  validation => is_instance_of('Zing::App'),
};

register {
  name => 'Cartridge',
  parent => 'Object',
  validation => is_instance_of('Zing::Cartridge'),
};

register {
  name => 'Channel',
  parent => 'Object',
  validation => is_instance_of('Zing::Channel'),
};

register {
  name => 'Cli',
  parent => 'Object',
  validation => is_instance_of('Zing::Cli'),
};

register {
  name => 'Cursor',
  parent => 'Object',
  validation => is_instance_of('Zing::Cursor'),
};

register {
  name => 'Daemon',
  parent => 'Object',
  validation => is_instance_of('Zing::Daemon'),
};

register {
  name => 'Data',
  parent => 'Object',
  validation => is_instance_of('Zing::Data'),
};

register {
  name => 'Domain',
  parent => 'Object',
  validation => is_instance_of('Zing::Domain'),
};

register {
  name => 'Entity',
  parent => 'Object',
  validation => is_instance_of('Zing::Entity'),
};

register {
  name => 'Env',
  parent => 'Object',
  validation => is_instance_of('Zing::Env'),
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
  name => 'Journal',
  parent => 'Object',
  validation => is_instance_of('Zing::Journal'),
};

register {
  name => 'Kernel',
  parent => 'Object',
  validation => is_instance_of('Zing::Kernel'),
};

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
  name => 'Lookup',
  parent => 'Object',
  validation => is_instance_of('Zing::Lookup'),
};

register {
  name => 'Loop',
  parent => 'Object',
  validation => is_instance_of('Zing::Loop'),
};

register {
  name => 'Logger',
  parent => 'Object',
  validation => is_instance_of('FlightRecorder'),
};

register {
  name => 'Mailbox',
  parent => 'Object',
  validation => is_instance_of('Zing::Mailbox'),
};

register {
  name => 'Node',
  parent => 'Object',
  validation => is_instance_of('Zing::Node'),
};

register {
  name => 'Poll',
  parent => 'Object',
  validation => is_instance_of('Zing::Poll'),
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

declare 'Schedule',
  as Tuple([Str(), ArrayRef([Str()]), HashRef()]);

declare 'Scheme',
  as Tuple([Str(), ArrayRef(), Int()]);

register {
  name => 'Savepoint',
  parent => 'Object',
  validation => is_instance_of('Zing::Savepoint'),
};

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

register {
  name => 'Zing',
  parent => 'Object',
  validation => is_instance_of('Zing'),
};

1;