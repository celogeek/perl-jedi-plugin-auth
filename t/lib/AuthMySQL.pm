package t::lib::AuthMySQL;
use Jedi::App;
use Jedi::Plugin::Session;
use Jedi::Plugin::Auth 'MySQL';
with 't::lib::Role';

sub jedi_app {shift->init_app}

1;
