package t::lib::AuthSQLite;
use Jedi::App;
use Jedi::Plugin::Session;
use Jedi::Plugin::Auth 'SQLite';
with 't::lib::Role';

sub jedi_app {shift->init_app}

1;
