use Zing::Store;

package Redis;

use Carp;

*{"Redis::new"} = $INC{'Redis.pm'} = sub {
  carp "Redis disabaled while testing"; undef
};

package Zing::Store;

our $DATA = {};

sub drop {
  my ($self, $key) = @_;
  delete $DATA->{$key};
  return 'OK';
}

sub keys {
  my ($self, $key) = @_;
  my $re = join(':', $self->term($key), '.*');
  return [grep /$re/, keys %$DATA];
}

sub pull {
  my ($self, $key) = @_;
  my $get = pop @{$DATA->{$key}} if $DATA->{$key};
  return $get ? $self->load($get) : $get;
}

sub push {
  my ($self, $key, $val) = @_;
  my $set = $self->dump($val);
  return push @{$DATA->{$key}}, $set;
}

sub recv {
  my ($self, $key) = @_;
  my $get = $DATA->{$key};
  return $get ? $self->load($get) : $get;
}

sub send {
  my ($self, $key, $val) = @_;
  my $set = $self->dump($val);
  $DATA->{$key} = $set;
  return 'OK';
}

sub size {
  my ($self, $key) = @_;
  return $DATA->{$key} ? scalar(@{$DATA->{$key}}) : 0;
}

sub slot {
  my ($self, $key, $pos) = @_;
  my $get = $DATA->{$key}->[$pos];
  return $get ? $self->load($get) : $get;
}

sub test {
  my ($self, $key) = @_;
  return int exists $DATA->{$key};
}

package Test::Zing;

use Zing::Daemon;
use Zing::Fork;
use Zing::Logic;
use Zing::Loop;

use Data::Object::Space;

our $PIDS = $$ + 1;

# Zing/Daemon
{
  my $space = Data::Object::Space->new(
    'Zing/Daemon'
  );
  $space->inject(fork => sub {
    $ENV{ZING_TEST_FORK} || $PIDS++;
  });
  $space->inject(start => sub {
    my ($self, @args) = @_;
    $self->execute(@args);
  });
}

# Zing/Fork
{
  my $space = Data::Object::Space->new(
    'Zing/Fork'
  );
  $space->inject(execute => sub {
    my ($self) = @_;
    my $pid = $ENV{ZING_TEST_FORK} || $PIDS++;
    $self->space->load;
    my $process = $self->processes->{$pid} = $self->space->build(
      @{$self->scheme->[1]},
      node => Zing::Node->new(pid => $pid),
      parent => $self->parent,
    );
    $process->execute;
    $process
  });
  $space->inject(kill => sub {
    $ENV{ZING_TEST_KILL} || 0;
  });
  $space->inject(waitpid => sub {
    $ENV{ZING_TEST_WAIT} || -1;
  });
}

# Zing/Logic
{
  my $space = Data::Object::Space->new(
    'Zing/Logic'
  );
  $space->inject(kill => sub {
    $ENV{ZING_TEST_KILL} || 0;
  });
}

# Zing/Loop
{
  my $space = Data::Object::Space->new(
    'Zing/Loop'
  );
  $space->inject(execute => sub {
    my ($self, @args) = @_;
    $self->exercise(@args); # always run once
  });
}

1;
