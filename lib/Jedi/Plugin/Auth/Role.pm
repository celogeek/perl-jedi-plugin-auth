package Jedi::Plugin::Auth::Role;

# ABSTRACT: Imported Role for Jedi::Plugin::Auth

use strict;
use warnings;
# VERSION

use feature 'state';
use Carp;
use Digest::SHA1 qw/sha1/;
use Data::UUID;
use Path::Class;
use Jedi::Plugin::Auth::DB;
use DBIx::Class::Migration;
use JSON;

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

# init the BDB databases
has '_jedi_auth_db' => (is => 'lazy');
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

before jedi_app => sub {
  my ($app) = @_;
  croak "You need to include and configure Jedi::Plugin::Session first." if !$app->can('jedi_session_setup');
};

=method jedi_auth_signin

Create a new user

 $app->jedi_auth_signin(
    user     => 'admin',
    password => 'admin',
    uuid     => 'XXXXXXXXXXXXXXX' #SHA1 Hex Base64
    roles    => ['admin'],
    info     => {
      activated => 0,
      label     => 'Administrator',
      email     => 'admin@admin.local',
      blog      => 'http://blog.celogeek.com',
      live      => 'geistteufel@live.fr',
      created_at => 1388163353,
      last_login => 1388164353,
    }
 );

Roles are dynamically added. Your apps need to handle the relation between each role.

For example : admin include poweruser, user ...

=cut

sub jedi_auth_signin {
  my ($self, %params) = @_;
  state $uuid_generator = Data::UUID->new;
  my @missing;
  for my $key(qw/user password roles/) {
    push @missing, $key if !defined $params{$key};
  }
  return { status => 'ko', missing => \@missing } if @missing;

  $params{roles} = [split(/,/, $params{roles} // '')] if ref $params{roles} ne 'ARRAY';
  $params{info} //= {};

  my $user;

  return { status => 'ko', error_msg => "$@" } if ! eval {
    $user = $self->_jedi_auth_db->resultset('User')->create({
      user => $params{user},
      password => sha1($params{password}),
      uuid => $uuid_generator->create(),
      info => encode_json($params{info}),
    });
    1;
  };

  for my $role_name(@{$params{roles}}) {
    $user->add_to_roles({name => $role_name});
  }

  return { status => 'ok' };
}

=method jedi_auth_login

Login the user

  $app->jedi_auth_login(
    user     => 'admin',
    password => 'admin',
  );

  Return :
  
    0 : auth failed
    1 : auth ok

=cut

sub jedi_auth_login {

}

=method jedi_auth_logout

Logout the current login user

  $app->jedi_auth_logout

=cut

sub jedi_auth_logout {

}

=method jedi_auth_update

Update the user account

  $app->jedi_auth_update(
    user => 'admin',
    info => {
      activated => 1,
    }
  )

It will update the 'admin' user, and add/change the info.activated to 1. All the other info will be keep.

To clear an info key :

  $app->jedi_auth_update(
    user => 'admin',
    info => {
      blog => undef,
    }
  )

=cut

sub jedi_auth_update {

}

=method jedi_auth_users_with_role

Return the list of user with a specific role.

Only the "user" key is returned

  $app->jedi_auth_users_with_role('admin');

  # ["admin"]

=cut

sub jedi_auth_users_with_role {

}

=method jedi_auth_users_count

Return the number of users in the databases

  $app->jedi_auth_users_count()

  # 1

=cut

sub jedi_auth_users_count {

}

=method jedi_auth_user_roles

Return the role of an user

  $app->jedi_auth_user_roles('celogeek')

  # ["admin", "reviewer"]

=cut

sub jedi_auth_user_roles {

}

=method jedi_auth_user_info

Return the info of the users

  $app->jedi_auth_user_info('admin')

  # {
  #    activated => 0,
  #    label     => 'Administrator',
  #    email     => 'admin@admin.local',
  #    blog      => 'http://blog.celogeek.com',
  #    live      => 'geistteufel@live.fr',
  # }

  $app->jedi_auth_user_info('admin', 'activated')

  # 0

  $app->jedi_auth_user_info('admin', 'email')

  # admin@admin.local

=cut

sub jedi_auth_user_info {

}

1;