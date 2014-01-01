package Jedi::Plugin::Auth::DB::Result::User;

# ABSTRACT: ResultSet for User table

use strict;
use warnings;
# VERSION

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('jedi_auth_users');
__PACKAGE__->add_column(id => {data_type => 'integer'});
__PACKAGE__->add_columns(qw/user password uuid info/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint(
  uniq_user => [qw/user/],
);

__PACKAGE__->add_unique_constraint(
  uniq_user => [qw/uuid/],
);

__PACKAGE__->has_many(user_roles => 'Jedi::Plugin::Auth::DB::Result::UsersRoles', 'user_id');
__PACKAGE__->many_to_many(roles => 'user_roles' => 'role_id');

1;
