package Zing::Store::Pg;

use 5.014;

use strict;
use warnings;

use registry 'Zing::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Store';

# VERSION

# ATTRIBUTES

has client => (
  is => 'ro',
  isa => 'InstanceOf["DBI::db"]',
  new => 1,
);

fun new_client($self) {
  my $dbname = $ENV{ZING_DBNAME} || 'zing';
  my $dbhost = $ENV{ZING_DBHOST} || 'localhost';
  my $dbport = $ENV{ZING_DBPORT} || '5432';
  my $dbuser = $ENV{ZING_DBUSER} || 'postgres';
  my $dbpass = $ENV{ZING_DBPASS};
  require DBI; DBI->connect(
    join(';',
      "dbi:Pg:dbname=$dbname",
      $dbhost ? join('=', 'host', $dbhost) : (),
      $dbport ? join('=', 'port', $dbport) : (),
    ),
    $dbuser, $dbpass,
    {
      AutoCommit => 1,
      PrintError => 0,
      RaiseError => 1
    }
  );
}

has table => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_table($self) {
  $ENV{ZING_DBZONE} || 'entities'
}

# BUILDERS

fun new_encoder($self) {
  require Zing::Encoder::Json; Zing::Encoder::Json->new;
}

fun BUILD($self) {
  my $client = $self->client;
  my $table = $self->table;
  do {
    $client->do(
      qq{create table if not exists "$table" (
        "key" varchar primary key, "value" text not null
      )}
    );
  }
  unless (defined(do{
    local $@;
    local $client->{RaiseError} = 0;
    local $client->{PrintError} = 0;
    eval {
      $client->do("select 1 from "$table" where 1 = 1")
    }
  }));
  return $self;
}

fun DESTROY($self) {
  $self->client->disconnect;
  return $self;
}

# METHODS

method drop(Str $key) {
  my $table = $self->table;
  if (my $data = $self->recv($key)) {
    $self->client->begin_work;
    $self->client->prepare(
      qq{delete from "$table" where "key" = ?},
    )->execute($key);
    $self->client->commit;
    return 1;
  }
  return 0;
}

method keys(Str $query) {
  $query =~ s/\*/%/g;
  my $table = $self->table;
  my $data = $self->client->selectall_arrayref(
    qq{select "key" from "$table" where "key" like ?},
    { Slice => {} },
    $query,
  );
  return [map $$_{key}, @$data];
}

method lpull(Str $key) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      $self->client->begin_work;
      my $result = shift @{$data->{list}};
      $self->send($key, $data);
      $self->client->commit;
      return $result;
    }
  }
  return undef;
}

method lpush(Str $key, HashRef $val) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      $self->client->begin_work;
      my $result = unshift @{$data->{list}}, $val;
      $self->send($key, $data);
      $self->client->commit;
      return $result;
    }
    else {
      return undef;
    }
  }
  else {
    $self->client->begin_work;
    my $data = {list => []};
    my $result = unshift @{$data->{list}}, $val;
    $self->send($key, $data);
    $self->client->commit;
    return $result;
  }
}

method read(Str $key) {
  my $table = $self->table;
  my $data = $self->client->selectall_arrayref(
    qq{select "value" from "$table" where "key" = ?},
    { Slice => {} },
    $key,
  );
  return @$data ? $data->[0]{value} : undef;
}

method recv(Str $key) {
  my $data = $self->read($key);
  return $data ? $self->decode($data) : $data;
}

method rpull(Str $key) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      $self->client->begin_work;
      my $result = pop @{$data->{list}};
      $self->send($key, $data);
      $self->client->commit;
      return $result;
    }
  }
  return undef;
}

method rpush(Str $key, HashRef $val) {
  if ($self->test($key)) {
    if (my $data = $self->recv($key)) {
      $self->client->begin_work;
      my $result = push @{$data->{list}}, $val;
      $self->send($key, $data);
      $self->client->commit;
      return $result;
    }
    else {
      return undef;
    }
  }
  else {
    $self->client->begin_work;
    my $data = {list => []};
    my $result = push @{$data->{list}}, $val;
    $self->send($key, $data);
    $self->client->commit;
    return $result;
  }
}

method send(Str $key, HashRef $val) {
  my $set = $self->encode($val);
  $self->write($key, $set);
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
  my $table = $self->table;
  my $data = $self->client->selectall_arrayref(
    qq{select true from "$table" where "key" = ?},
    { Slice => {} },
    $key,
  );
  return !!@$data;
}

method write(Str $key, Str $data) {
  my $table = $self->table;
  $self->client->prepare(
    qq{insert into "$table" values (?, ?)
    on conflict ("key")
    do update set "value" = EXCLUDED.value},
  )->execute($key, $data);
  return $self;
}

1;
