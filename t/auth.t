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
$jedi->road('/', 't::lib::Auth');

test_psgi $jedi->start, sub {
  my $cb = shift;

  subtest "signin" => sub {
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

    subtest "signin user" => sub 
    {
            my $res = $cb->(GET '/signin?user=test&password=test&roles=test,admin&info={"activated":"1"}');
            my $resp = decode_json($res->content);
            is $resp->{status}, 'ok', 'status ok';
            is $resp->{user}, 'test', 'user name ok';
            cmp_bag $resp->{roles}, ['test', 'admin'], 'roles ok';
            like $resp->{uuid}, qr{^\w+\-\w+\-\w+\-\w+\-\w+$}x, 'uuid ok';
            is_deeply $resp->{info}, {activated => 1}, 'info is ok';
    };
    subtest "signin user2" => sub
    {
            my $res = $cb->(GET '/signin?user=test2&password=test&roles=test&info={"activated":"0"}');
            my $resp = decode_json($res->content);
            is $resp->{status}, 'ok', 'status ok';
            is $resp->{user}, 'test2', 'user name ok';
            cmp_bag $resp->{roles}, ['test'], 'roles ok';
            like $resp->{uuid}, qr{^\w+\-\w+\-\w+\-\w+\-\w+$}x, 'uuid ok';
            is_deeply $resp->{info}, {activated => 0}, 'info is ok';
    };
  
  };

  subtest "login" => sub {

    {
            my $res = $cb->(GET '/login');
            my $resp = decode_json($res->content);
            is $resp->{status}, 'ko', 'missing user';
    }
  
    {
            my $res = $cb->(GET '/login?user=test');
            my $resp = decode_json($res->content);
            is $resp->{status}, 'ko', 'missing password';
    }
  
    {
            # missing user
            my $res = $cb->(GET '/login?user=test3&password=test3');
            my $resp = decode_json($res->content);
            is $resp->{status}, 'ko', 'user unknown';
    }
  
    {
            # bad password
            my $res = $cb->(GET '/login?user=test2&password=test2');
            my $resp = decode_json($res->content);
            is $resp->{status}, 'ko', 'bad password';
    }
  
    subtest "login user" => sub {
            # bad password
            my $res = $cb->(GET '/login?user=test&password=test');
            my $resp = decode_json($res->content);
            is $resp->{status}, 'ok', 'status ok';
            is $resp->{user}, 'test', 'user name ok';
            cmp_bag $resp->{roles}, ['test', 'admin'], 'roles ok';
            like $resp->{uuid}, qr{^\w+\-\w+\-\w+\-\w+\-\w+$}x, 'uuid ok';
            is_deeply $resp->{info}, {activated => 1}, 'info is ok';
    }
  
  }
};

done_testing;
