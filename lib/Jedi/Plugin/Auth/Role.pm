package Jedi::Plugin::Auth::Role;

# ABSTRACT: Imported Role for Jedi::Plugin::Auth

use strict;
use warnings;
# VERSION

use Moo::Role;

=method jedi_auth_signin

Create a new user

 $app->jedi_auth_signin(
    user     => 'admin',
    password => 'admin',
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