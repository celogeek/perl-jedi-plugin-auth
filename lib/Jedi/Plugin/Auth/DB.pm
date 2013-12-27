package Jedi::Plugin::Auth::DB;

# ABSTRACT: Schema for SQLite Auth

use strict;
use warnings;

our $VERSION = 1; #Schema Version

use base qw/DBIx::Class::Schema/;
 
__PACKAGE__->load_classes({
  __PACKAGE__ . '::Result' => [qw/User Role UsersRoles/]
});

1;