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
  name => 'Error',
  parent => 'Object',
  validation => is_instance_of('Zing::Error'),
},
{
  name => 'Logger',
  parent => 'Object',
  validation => is_capable_of(qw(debug info warn error fatal)),
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
};

1;