package Jedi::Plugin::Auth::DB::Result::User;

# ABSTRACT: ResultSet for User table

use strict;
use warnings;
# VERSION

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('jedi_auth_users');
__PACKAGE__->add_column(id => {data_type => 'integer'});
__PACKAGE__->add_columns(qw/user password info/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint(
  uniq_user => [qw/user/],
);


1;
