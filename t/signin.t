#!perl
use Test::Most 'die';
use HTTP::Request::Common;
use Plack::Test;
use Module::Runtime qw/use_module/;
use Carp;
use JSON;
use Jedi;
use Test::File::ShareDir
  -share => {
    -dist => { 'Jedi-Plugin-Auth' => 'share' }
  }
;

my $jedi = Jedi->new;
$jedi->road('/', 't::lib::SignIn');

test_psgi $jedi->start, sub {
  my $cb = shift;
  {
          my $res = $cb->(GET '/signin');
          my $resp = decode_json($res->content);
          is_deeply($resp, {status => 'ko', missing => [qw/user password roles/]}, 'missing user, password, roles');
  }
  {
          my $res = $cb->(GET '/signin?user=test');
          my $resp = decode_json($res->content);
          is_deeply($resp, {status => 'ko', missing => [qw/password roles/]}, 'missing password, roles');
  }
  {
          my $res = $cb->(GET '/signin?user=test&password=test');
          my $resp = decode_json($res->content);
          is_deeply($resp, {status => 'ko', missing => [qw/roles/]}, 'missing roles');
  }
  {
          my $res = $cb->(GET '/signin?user=test&password=test&roles=test');
          note $res->content;
          my $resp = decode_json($res->content);
          is_deeply($resp, {status => 'ok'}, 'response ok');
  }
};

done_testing;