#!perl
use strict;
use warnings;
use Test::More;

use Jedi;

my $jedi = Jedi->new;
ok ! eval { $jedi->road('/', 't::lib::MissingSession'); 1 }, 'missing session';
like $@, qr{\QYou need to include and configure Jedi::Plugin::Session first.\E}, 'error ok';

done_testing;
