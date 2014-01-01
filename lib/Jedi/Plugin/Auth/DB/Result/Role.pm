package Jedi::Plugin::Auth::DB::Result::Role;

# ABSTRACT: ResultSet for Role table

use strict;
use warnings;
# VERSION

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('jedi_auth_roles');
__PACKAGE__->add_column(id => {data_type => 'integer'});
__PACKAGE__->add_columns(qw/name/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint(
  uniq_name => [qw/name/],
);

__PACKAGE__->has_many(user_roles => 'Jedi::Plugin::Auth::DB::Result::UsersRoles', 'role_id');
__PACKAGE__->many_to_many(roles => 'user_roles' => 'user_id');

1;