package Jedi::Plugin::Auth::Backend::MySQL;

# ABSTRACT: MySQL backend

use strict;
use warnings;
# VERSION

use Carp;
use Path::Class;
use DBIx::Class::Migration;

# connect / create / prepare db
sub _prepare_database {
    my (%params) = @_;

    my ($db, $host, $port, $user, $password, $prefix) = @params{qw{
     database_name
     hostname
     port
     user
     password
     prefix
    }};

  my @connect_info = grep { defined } ("DBI:mysql:$db;host=$host;port=$port", $user, $password);

  my $schema = Jedi::Plugin::Auth::DB->connect(@connect_info);

  my $migration = DBIx::Class::Migration->new(
    schema => $schema,
  );

  $migration->install_if_needed;
  $migration->upgrade;

  return $schema;
}

use Moo::Role;

sub _build__jedi_auth_db {
    my ($self) = @_;
    my $class = ref $self;
    my ($db, $host, $port, $user, $password, $prefix) = @{$self->jedi_config->{$class}{auth}{mysql}}{qw/
      database_name hostname port user password prefix
    /};

    $db //= 'test';
    $host //= 'localhost';
    $port //= 3306;
    $user //= 'root';

    if (!defined $prefix) {
      $prefix = lc($class);
      $prefix =~ s/::/_/gx;
    }

    return _prepare_database(
     database_name => $db,
     hostname => $host,
     port => $port,
     user => $user,
     password => $password,
     prefix => $prefix
    );
}

1;
