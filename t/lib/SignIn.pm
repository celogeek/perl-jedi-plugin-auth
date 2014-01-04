package t::lib::SignIn;
use Jedi::App;
use Jedi::Plugin::Session;
use Jedi::Plugin::Auth;
use JSON;

sub jedi_app {
  my ($app) = @_;

  $app->get('/signin', sub {
    my ($app, $request, $response) = @_;
    my $res = $app->jedi_auth_signin(
      user => $request->params->{user},
      password => $request->params->{password},
      roles => $request->params->{roles},
    );
    $response->status(200);
    $response->body(encode_json($res));
  })
}

1;