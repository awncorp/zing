# NAME

Zing - Multi-Process Management System

# ABSTRACT

Actor Toolkit and Multi-Process Management System

# SYNOPSIS

    use Zing;

    my $zing = Zing->new(scheme => ['MyApp', [], 1]);

    # $zing->execute;

# DESCRIPTION

This distribution includes an actor-model architecture toolkit and
multi-process management system which provides primatives for building
resilient, reactive, concurrent, distributed message-driven applications in
Perl 5. If you're unfamiliar with this architectural pattern, learn more about
["the actor model"](https://en.wikipedia.org/wiki/Actor_model).

# INHERITS

This package inherits behaviors from:

[Zing::Watcher](https://metacpan.org/pod/Zing%3A%3AWatcher)

# LIBRARIES

This package uses type constraints from:

[Zing::Types](https://metacpan.org/pod/Zing%3A%3ATypes)

# ATTRIBUTES

This package has the following attributes:

## scheme

    scheme(Scheme)

This attribute is read-only, accepts `(Scheme)` values, and is required.

# METHODS

This package implements the following methods:

## start

    start() : Kernel

The start method builds a [Zing::Kernel](https://metacpan.org/pod/Zing%3A%3AKernel) and executes its event-loop.

- start example #1

        # given: synopsis

        $zing->start;

# COMMANDS

Given the following process (actor):

    # in lib/MyApp.pm

    package MyApp;

    use parent 'Zing::Single';

    sub perform {
      # do something (once)
    }

    1;

With an application cartridge specifying 4 forks:

    # in app/myapp

    ['MyApp', [], 4]

The [zing](https://metacpan.org/pod/zing) command-line application lets you manage Zing applications from the
command-line using these commands:

## start

    $ zing start app/myapp

The `start` command loads an application _cartridge_ which returns a
["scheme"](https://metacpan.org/pod/Zing%3A%3ATypes#scheme) and runs it as a daemon.

## stop

    $ zing stop app/myapp

The `stop` command finds a running application by its PID (process ID) and
terminates the process.

## logs

    $ zing logs

The `logs` command taps the centralized log source and outputs new events to
STDOUT (standard output).

# PRIMATIVES

This distribution provides a collection of actor-model primitives which can be
used to create sophisticated and powerful distributed systems, organized within
intricate process topologies. The following is a directory of those primitives
listed by classification:

## messaging

These classes facilitate message-passing and communications:

- [Zing::Channel](https://metacpan.org/pod/Zing%3A%3AChannel): Shared Communication
- [Zing::Data](https://metacpan.org/pod/Zing%3A%3AData): Process Data
- [Zing::Dropbox](https://metacpan.org/pod/Zing%3A%3ADropbox): Transient Store
- [Zing::KeyVal](https://metacpan.org/pod/Zing%3A%3AKeyVal): Key/Value Store
- [Zing::Mailbox](https://metacpan.org/pod/Zing%3A%3AMailbox): Process Mailbox
- [Zing::PubSub](https://metacpan.org/pod/Zing%3A%3APubSub): Pub/Sub Store
- [Zing::Queue](https://metacpan.org/pod/Zing%3A%3AQueue): Message Queue
- [Zing::Registry](https://metacpan.org/pod/Zing%3A%3ARegistry): Process Registry
- [Zing::Repo](https://metacpan.org/pod/Zing%3A%3ARepo): Generic Store
- [Zing::Store](https://metacpan.org/pod/Zing%3A%3AStore): Storage Abstraction

## processes

These base classes implement the underlying process (actor) logic:

- [Zing](https://metacpan.org/pod/Zing): Process Wrapper
- [Zing::Kernel](https://metacpan.org/pod/Zing%3A%3AKernel): Kernel Process
- [Zing::Launcher](https://metacpan.org/pod/Zing%3A%3ALauncher): Scheme Launcher
- [Zing::Process](https://metacpan.org/pod/Zing%3A%3AProcess): Processing Unit
- [Zing::Ring](https://metacpan.org/pod/Zing%3A%3ARing): Process Ring
- [Zing::Scheduler](https://metacpan.org/pod/Zing%3A%3AScheduler): Scheme Launcher
- [Zing::Simple](https://metacpan.org/pod/Zing%3A%3ASimple): Simple Process
- [Zing::Single](https://metacpan.org/pod/Zing%3A%3ASingle): Single Process
- [Zing::Spawner](https://metacpan.org/pod/Zing%3A%3ASpawner): Scheme Spawner
- [Zing::Watcher](https://metacpan.org/pod/Zing%3A%3AWatcher): Watcher Process
- [Zing::Worker](https://metacpan.org/pod/Zing%3A%3AWorker): Worker Process

## ready-made

These classes are ready-made process implementations using callbacks:

- [Zing::Zang](https://metacpan.org/pod/Zing%3A%3AZang): Process Implementation
- [Zing::Zang::Launcher](https://metacpan.org/pod/Zing%3A%3AZang%3A%3ALauncher): Process Launcher
- [Zing::Zang::Simple](https://metacpan.org/pod/Zing%3A%3AZang%3A%3ASimple): Process Performer
- [Zing::Zang::Single](https://metacpan.org/pod/Zing%3A%3AZang%3A%3ASingle): Single-Task Process
- [Zing::Zang::Spawner](https://metacpan.org/pod/Zing%3A%3AZang%3A%3ASpawner): Process Spawner
- [Zing::Zang::Watcher](https://metacpan.org/pod/Zing%3A%3AZang%3A%3AWatcher): Process Watcher
- [Zing::Zang::Worker](https://metacpan.org/pod/Zing%3A%3AZang%3A%3AWorker): Worker Process

# FEATURES

All features are implemented using classes and objects. The following is a list
of features currently enabled by this toolkit:

## actor-model

    use Zing::Process;

    my $p1 = Zing::Process->new(name => 'p1');
    my $p2 = Zing::Process->new(name => 'p2');

    $p1->mailbox->send($p2->name, { action => 'greeting' });

This distribution provides a toolkit for creating processes (actors) which can
be run in isolation and which communicate with other processes through
message-passing.

## asynchronous

    # in process (1)
    use Zing::Process;

    my $p1 = Zing::Process->new(name => 'p1');

    $p1->execute;

    # in process (2)
    use Zing::Process;

    my $p2 = Zing::Process->new(name => 'p2');

    my $friends = $p2->registry->keys;

    for my $friend (@$friends) {
      # send each registered process a message
      $p2->send($friend, { discovery => $p2->name });
    }

    $p2->execute;

This distribution provides a multi-process management system which allows
processes to be deployed and managed separately having the ability to
communicate across threads of execution.

## atomicity

    # in process (1)
    use Zing::KeyVal;

    my $i = 0;
    my $kv = Zing::KeyVal->new(name => 'stash');

    while ($i < 1_000) {
      $kv->send('random', { value => 1 });

      # my $data = $kv->recv('random');
    }

    # in process (2)
    use Zing::KeyVal;

    my $i = 0;
    my $kv = Zing::KeyVal->new(name => 'stash');

    while ($i < 1_000) {
      $kv->send('random', { value => 2 });

      # my $data = $kv->recv('random');
    }

This distribution provides data storage abstractions which perform atomic reads
and write by leveraging [Redis](https://redis.io) as the default data storage
backend.

## chainable

    use Zing::Process;
    use Zing::Ring;

    my $p1 = Zing::Process->new(name => 'p1');
    my $p2 = Zing::Process->new(name => 'p2');

    my $ring = Zing::Ring->new(processes => [$p1, $p2]);

    $ring->execute;

This distribution provides a mechanism for chaining (i.e. joining) two or more
processes together and executing them in a turn-based manner. This ability
allows you to design complex hierarchical process topologies.

## channels

    # in process (1)
    use Zing::Channel;

    my $chan = Zing::Channel->new(name => 'chat');

    while (1) {
      if (my $data = $chan->recv) {
        # broadcast received
        warn $data->{text};
      }
    }

    # in process (2)
    use Zing::Channel;

    my $chan = Zing::Channel->new(name => 'chat');

    while (1) {
      if (my $data = $chan->recv) {
        # broadcast received
        warn $data->{text};
      }
    }

This distribution provides the means for braodcasting and communicating to
multiple processes simulaneously through channels which are similar to FIFO
queues.

## clusterable

    # in process (1) on cluster (1)
    use Zing::Queue;

    my $queue = Zing::Queue->new(name => 'tasks', target => 'global');

    # pull from global queue
    $queue->recv;

    # in process (1) on cluster (2)
    use Zing::Queue;

    my $queue = Zing::Queue->new(name => 'tasks', target => 'global');

    # pull from global queue
    $queue->recv;

This distribution provides support cross-cluster communication and thus
operations. Using federated Redis as the data storage backend means you can
scale your deployments without changing your implementations.

## configuration

    # configure where the command-line tool finds catridges
    ZING_HOME=/tmp

    # configure the hostname used in process registration
    ZING_HOST=0.0.0.0
    ZING_HOST=68.80.90.100

    # configure Redis driver without touching your source code
    ZING_REDIS='every=1_000_000,reconnect=60'
    ZING_REDIS='sentinels=127.0.0.1:12345|127.0.0.1:23456,sentinels_cnx_timeout=0.1'
    ZING_REDIS='server=192.168.0.1:6379,debug=0'

This distribution provides environment variables that let you customize how
Zing operates and behaves without the need to modify source code. These
attributes are not required and fallback to sane defaults.

## distributed

    # in process (1..n) on cluster (1)
    use Zing;

    my $zing = Zing->new(scheme => ['MyApp', [], 16]);

    $zing->execute;

    # in process (1..n) on cluster (2)
    use Zing;

    my $zing = Zing->new(scheme => ['MyApp', [], 16]);

    $zing->execute;

    # in process (1..n) on cluster (3)
    use Zing;

    my $zing = Zing->new(scheme => ['MyApp', [], 16]);

    $zing->execute;

This distribution provides a collection of actor-model primitives which can be
used to create sophisticated and powerful distributed systems, organized within
intricate process topologies.

## event-driven

    # in process (1)
    package MyApp::FileUpoad;

    use parent 'Zing::Process';

    sub receive {
      my ($self, $from, $data) = @_;

      # react to file-upload events

      return;
    }

    my $p1 = MyApp::FileUpoad->new;

    $p1->execute;

    # in process (2)
    package MyApp::TextTranslate;

    use parent 'Zing::Process';

    sub receive {
      my ($self, $from, $data) = @_;

      # react to text-translate events

      return;
    }

    my $p2 = MyApp::TextTranslate->new;

    $p2->execute;

This distribution provides all the prerequisites needed to develop scalable
reactive event-driven applications distributed across one or several servers.

## fifo-queues

    # in process (1)
    use Zing::Queue;

    my $queue = Zing::Queue->new(name => 'tasks');

    # pull from queue
    $queue->send({ command => { ... } });
    $queue->send({ command => { ... } });
    $queue->send({ command => { ... } });
    $queue->send({ command => { ... } });

    # in process (2)
    use Zing::Queue;

    my $queue = Zing::Queue->new(name => 'tasks');

    # pull from FIFO queue
    $queue->recv;

This distribution provides high-performance FIFO message queues which enhance
messaging across processes when the order of operations and events is critical
and where duplicates can't be tolerated.

## hot-reloadable

    use Zing;
    use Zing::Daemon;

    my $daemon = Zing::Daemon->new(
      name => 'myapp-sleep',
      app => Zing->new(scheme => ['MyApp::Sleep', [], 4])
    );

    $daemon->execute; # pid 12345

    # $ kill -USR2 12345

This distribution provides zero-downtime through hot-reloading which is where
the process watchers (supervisors) keep the app running and gracefully reload
child processes at runtime.

## log-shipping

    use Zing::Zang;

    my $zang = Zing::Zang->new(on_perform => sub {
      my ($self) = @_;

      $self->log->fatal('something went wrong');

      return;
    });

    $zang->execute;

    # tap the logs using the command-line tool

    # $ zing logs

This distribution provides the ability to ship the logs of individual processes
to a specific centralized channel which can be tapped asynchronously,
especially by the command-line tool.

## mailboxes

    use Zing::Process;

    my $p1 = Zing::Process->new(name => 'p1');
    my $p2 = Zing::Process->new(name => 'p2');

    $p1->mailbox->send($p2->name, { say => 'ehlo' });

    my $message = $p2->mailbox->recv;

    $p2->mailbox->reply($message, { say => 'helo' });

This distribution provides every process with its own unique mailbox which can
receive messages from other processes as a means of cooperating through message
passing.

## management

    use Zing::Kernel;

    my $kernel = Zing::Kernel->new(scheme => ['MyApp::Logger', [], 2]);

    $kernel->execute;

This distribution provides a kernel process that can be used to manage the
deployment of child processes and is used to wrap cartridges by the
command-line tool when daemonizing process.

## multitasking

    use Zing::Zang;

    my $zang = Zing::Zang->new(
      on_perform => sub {
        # do something
      },
      on_receive => sub {
        # handle something
      },
    );

    $zang->execute;

This distribution provides all processes with an event-loop that allows them to
perform multiple operations in sequence and supports operating in a
non-blocking manner.

## non-blocking

    use Zing::Zang;

    my $zang = Zing::Zang->new(
      on_perform => sub {
        my ($self) = @_;

        $self->defer({ command => {...} }) and return;

        return;
      },
      on_receive => sub {
        my ($self, $from, $data) = @_;

        return unless $self->name eq $from; # from myself

        # do something

        return;
      }
    );

    $zang->exercise;

This distribution provides features that allow processes to operate in a
non-blocking manner, yielding and deferring operations, and chunking workloads.

## parallelism

    use Zing::Process;

    my $p1 = Zing::Process->new;

    my $f1 = $p1->spawn(['MyApp', [id => 12345] 1]);
    my $f2 = $p1->spawn(['MyApp', [id => 12346] 1]);

This distribution provides multiple ways of executing operations in parallel,
including spawning processes via forking with the guarantee of not creating
zombie processes.

## supervisors

    use Zing::Zang::Watcher;

    my $zang = Zing::Zang::Watcher->new(
      scheme => ['MyApp', [] 8]
    );

    $zang->exercise;

This distribution provides watcher processes which to supervise child processes
but also are capable of multitasking and performing other operations while
monitoring supervised processes.

# SEE ALSO

[The Actor Model](https://en.wikipedia.org/wiki/Actor_model)

[Concurrent Computation](https://www.amazon.com/Actors-Concurrent-Computation-Distributed-Systems/dp/026251141X)

[Concurrency in Go/Erlang](https://www.youtube.com/watch?v=2yiKUIDFc2I)

[The Akka Project](https://github.com/akka/akka)

[The Actorkit Project](https://github.com/influx6/actorkit)

[The Orleans Project](http://dotnet.github.io/orleans)

[The Pyakka Project](https://github.com/jodal/pykka)

[The Reactive Manifesto](http://www.reactivemanifesto.org)

# AUTHOR

Al Newkirk, `awncorp@cpan.org`

# LICENSE

Copyright (C) 2011-2019, Al Newkirk, et al.

This is free software; you can redistribute it and/or modify it under the terms
of the The Apache License, Version 2.0, as elucidated in the ["license
file"](https://github.com/iamalnewkirk/zing/blob/master/LICENSE).

# PROJECT

[Wiki](https://github.com/iamalnewkirk/zing/wiki)

[Project](https://github.com/iamalnewkirk/zing)

[Initiatives](https://github.com/iamalnewkirk/zing/projects)

[Milestones](https://github.com/iamalnewkirk/zing/milestones)

[Contributing](https://github.com/iamalnewkirk/zing/blob/master/CONTRIBUTE.md)

[Issues](https://github.com/iamalnewkirk/zing/issues)
