package Jedi::Plugin::Auth::Backend::SQLite;

# ABSTRACT: SQLite backend

use strict;
use warnings;
# VERSION

use Carp;
use Path::Class;
use DBIx::Class::Migration;

# connect / create / prepare db
sub _prepare_database {
  my ($dbfile) = @_;
  my @connect_info = ("dbi:SQLite:dbname=" . $dbfile->stringify);
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
    my $sqlite_path = $self->jedi_config->{$class}{auth}{sqlite}{path};
    if (!defined $sqlite_path) {
      $sqlite_path = dir(File::ShareDir::dist_dir('Jedi-Plugin-Auth'));
    }
    croak "SQLite path is missing and cannot be guest. Please setup the configuration file."
     if !defined $sqlite_path;
    my $app_dir = dir($sqlite_path, split(/::/x, $class));
    my $sqlite_db_file = file($app_dir . '.db');
    $sqlite_db_file->dir->mkpath;
    return _prepare_database($sqlite_db_file);
}

1;