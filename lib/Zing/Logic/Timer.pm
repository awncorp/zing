package Zing::Logic::Timer;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Logic';

use Zing::Flow;
use Zing::Queue;

use Time::Crontab;
use Time::Piece;

# VERSION

# ATTRIBUTES

has 'on_timer' => (
  is => 'ro',
  isa => 'CodeRef',
  new => 1,
);

fun new_on_timer($self) {
  $self->can('handle_timer_event')
}

has 'schedules' => (
  is => 'ro',
  isa => 'ArrayRef[Schedule]',
  new => 1
);

fun new_schedules($self) {
  $self->process->schedules
}

has 'relays' => (
  is => 'ro',
  isa => 'HashRef[Queue]',
  new => 1
);

fun new_relays($self) {
  +{map {$_, Zing::Queue->new(name => $_)} map @{$$_[1]}, @{$self->schedules}}
}

# SHIMS

sub _tick {
  localtime->truncate(to => 'minute')->epoch
}

sub _time {
  CORE::time
}

# METHODS

method flow() {
  my $step_0 = $self->next::method;

  my $step_1 = Zing::Flow->new(
    name => 'on_timer',
    code => fun($step, $loop) { $self->trace('on_timer')->($self) }
  );

  $step_0->append($step_1);
  $step_0
}

my $aliases = {
  # at 00:00 on day-of-month 1 in january
  '@yearly' => '0 0 1 1 *',
  # at 00:00 on day-of-month 1 in january
  '@annually' => '0 0 1 1 *',
  # at 00:00 on day-of-month 1
  '@monthly' => '0 0 1 * *',
  # at 00:00 on monday
  '@weekly' => '0 0 * * 1',
  # at 00:00 on saturday
  '@weekend' => '0 0 * * 6',
  # at 00:00 every day
  '@daily' => '0 0 * * *',
  # at minute 0 every hour
  '@hourly' => '0 * * * *',
  # at every minute
  '@minute' => '* * * * *',
};

method handle_timer_event($name) {
  my $process = $self->process;

  my $_tick = _tick;
  my $_time = _time;

  for (my $i = 0; $i < @{$self->schedules}; $i++) {
    # run each schedule initially, and then once per minute
    last if $_tick == (
      $self->{tick}[$i] || 0
    );

    # unpack schedule
    my $schedule = $self->schedules->[$i];
    my $frequency = $schedule->[0] || '';
    my $cronexpr = $aliases->{$frequency} || $frequency;
    my $queues = $schedule->[1];
    my $message = $schedule->[2];

    # cached crontab object
    my $cron = $self->{cron}[$i] ||= Time::Crontab->new($cronexpr);

    # next unless our times is here!
    next unless $cron->match($_time);

    # record tick for once-per-minute excution
    $self->{tick}[$i] = $_tick;

    # deliver messages to queues
    for my $name (@$queues) {
      $self->relays->{$name}->send($message);
    }
  }

  return $self;
}

1;
