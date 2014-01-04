package t::lib::Auth;
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
      info => decode_json($request->params->{info}//"{}"),
    );
    $response->status(200);
    $response->body(encode_json($res));
  });

  $app->get('/login', sub {
    my ($app, $request, $response) = @_;
    my $res = $app->jedi_auth_login(
      $request,
      user => $request->params->{user},
      password => $request->params->{password},
    );
    $response->status(200);
    $response->body(encode_json($res));
  });

  $app->get('/auth_session', sub {
    my ($app, $request, $response) = @_;
    $response->status(200);
    $response->body(encode_json($request->session_get // {}));
  });

}

1;
