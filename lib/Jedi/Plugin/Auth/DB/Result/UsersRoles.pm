package Jedi::Plugin::Auth::DB::Result::UsersRoles;

# ABSTRACT: ResultSet for UsersRoles table

use strict;
use warnings;
# VERSION

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('jedi_auth_users_roles');
__PACKAGE__->add_column(user_id => {data_type => 'integer'});
__PACKAGE__->add_column(role_id => {data_type => 'integer'});
__PACKAGE__->set_primary_key(__PACKAGE__->columns);

1;