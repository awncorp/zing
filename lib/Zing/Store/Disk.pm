package Zing::Store::Disk;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Store';

use File::Spec;

# VERSION

# ATTRIBUTES

has root => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_root($self) {
  File::Spec->curdir
}

# BUILDERS

fun new_encoder($self) {
  require Zing::Encoder::Json; Zing::Encoder::Json->new;
}

# METHODS

method drop(Str $key) {
  return int(!!unlink $self->path($key));
}

method keys(Key $query) {
  my @paths = glob(File::Spec->catfile(
    $self->root, (map +($_ || '*'), (split(':', $query))[0..4])
  ));
  return [
    map {
      join(':', (reverse((reverse(File::Spec->splitdir($_)))[0..4])))
    }
    grep -f, @paths
  ];
}

method lpull(Str $key) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      my $result = shift @{$data->{list}};
      $self->send($key, $data);
      return $result;
    }
  }
  return undef;
}

method lpush(Str $key, HashRef $val) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      my $result = unshift @{$data->{list}}, $val;
      $self->send($key, $data);
      return $result;
    }
    else {
      return undef;
    }
  }
  else {
    my $data = {list => []};
    my $result = unshift @{$data->{list}}, $val;
    $self->send($key, $data);
    return $result;
  }
}

method path(Key $key) {
  my $dir = $self->root;
  mkdir $dir;
  for my $next ((split(':', $key))[0..3]) {
    $dir = File::Spec->catfile($dir, $next);
    mkdir $dir;
  }
  return File::Spec->catfile($self->root, split(':', $key));
}

method read(Str $file) {
  open my $fh, '<', $file
    or die "Can't open file ($file): $!";
  my $ret = my $data = '';
  while ($ret = $fh->sysread(my $buffer, 131072, 0)) {
    $data .= $buffer;
  }
  unless (defined $ret) {
    die "Can't read from file ($file): $!";
  }
  return $data;
}

method recv(Str $key) {
  my $data = $self->read($self->path($key));
  return $data ? $self->decode($data) : $data;
}

method rpull(Str $key) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      my $result = pop @{$data->{list}};
      $self->send($key, $data);
      return $result;
    }
  }
  return undef;
}

method rpush(Str $key, HashRef $val) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      my $result = push @{$data->{list}}, $val;
      $self->send($key, $data);
      return $result;
    }
    else {
      return undef;
    }
  }
  else {
    my $data = {list => []};
    my $result = push @{$data->{list}}, $val;
    $self->send($key, $data);
    return $result;
  }
}

method send(Str $key, HashRef $val) {
  my $set = $self->encode($val);
  $self->write($self->path($key), $set);
  return 'OK';
}

method size(Str $key) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      return scalar(@{$data->{list}});
    }
  }
  return 0;
}

method slot(Str $key, Int $pos) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      return $data->{list}[$pos];
    }
  }
  return undef;
}

method test(Str $key) {
  return -f $self->path($key) ? 1 : 0;
}

method write(Str $file, Str $data) {
  open my $fh, '>', $file
    or die "Can't open file ($file): $!";
  ($fh->syswrite($data) // -1) == length $data
    or die "Can't write to file ($file): $!";
  return $self;
}

1;
