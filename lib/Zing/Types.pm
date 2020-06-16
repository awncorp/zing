package Zing::Types;

use 5.014;

use strict;
use warnings;

use Data::Object::Types::Keywords;

use base 'Data::Object::Types::Library';

extends 'Types::Standard';

# VERSION

register
{
  name => 'Channel',
  parent => 'Object',
  validation => is_instance_of('Zing::Channel'),
},
{
  name => 'Data',
  parent => 'Object',
  validation => is_instance_of('Zing::Data'),
},
{
  name => 'Error',
  parent => 'Object',
  validation => is_instance_of('Zing::Error'),
},
{
  name => 'Flow',
  parent => 'Object',
  validation => is_instance_of('Zing::Flow'),
},
{
  name => 'Fork',
  parent => 'Object',
  validation => is_instance_of('Zing::Fork'),
},
{
  name => 'KeyVal',
  parent => 'Object',
  validation => is_instance_of('Zing::KeyVal'),
},
{
  name => 'Logic',
  parent => 'Object',
  validation => is_instance_of('Zing::Logic'),
},
{
  name => 'Loop',
  parent => 'Object',
  validation => is_instance_of('Zing::Loop'),
},
{
  name => 'Logger',
  parent => 'Object',
  validation => is_capable_of(qw(debug info warn error fatal)),
},
{
  name => 'Mailbox',
  parent => 'Object',
  validation => is_instance_of('Zing::Mailbox'),
},
{
  name => 'Message',
  parent => 'Object',
  validation => is_instance_of('Zing::Message'),
},
{
  name => 'Metadata',
  parent => 'Object',
  validation => is_instance_of('Zing::Metadata'),
},
{
  name => 'Node',
  parent => 'Object',
  validation => is_instance_of('Zing::Node'),
},
{
  name => 'Process',
  parent => 'Object',
  validation => is_instance_of('Zing::Process'),
},
{
  name => 'PubSub',
  parent => 'Object',
  validation => is_instance_of('Zing::PubSub'),
},
{
  name => 'Queue',
  parent => 'Object',
  validation => is_instance_of('Zing::Queue'),
},
{
  name => 'Registry',
  parent => 'Object',
  validation => is_instance_of('Zing::Registry'),
},
{
  name => 'Redis',
  parent => 'Object',
  validation => is_instance_of('Redis'),
},
{
  name => 'Repo',
  parent => 'Object',
  validation => is_instance_of('Zing::Repo'),
},
{
  name => 'Server',
  parent => 'Object',
  validation => is_instance_of('Zing::Server'),
},
{
  name => 'Space',
  parent => 'Object',
  validation => is_instance_of('Data::Object::Space'),
},
{
  name => 'Store',
  parent => 'Object',
  validation => is_instance_of('Zing::Store'),
},
{
  name => 'Task',
  parent => 'Object',
  validation => is_instance_of('Zing::Task'),
},
{
  name => 'Watcher',
  parent => 'Object',
  validation => is_instance_of('Zing::Watcher'),
},
{
  name => 'Worker',
  parent => 'Object',
  validation => is_instance_of('Zing::Worker'),
};

1;