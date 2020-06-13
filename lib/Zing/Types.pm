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
  name => 'Cmd',
  parent => 'Object',
  validation => is_instance_of('Zing::Cmd'),
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
  name => 'Space',
  parent => 'Object',
  validation => is_instance_of('Data::Object::Space'),
},
{
  name => 'Step',
  parent => 'Object',
  validation => is_instance_of('Zing::Step'),
},
{
  name => 'Store',
  parent => 'Object',
  validation => is_instance_of('Zing::Store'),
};

1;