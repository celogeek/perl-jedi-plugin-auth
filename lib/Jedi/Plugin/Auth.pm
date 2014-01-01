package Jedi::Plugin::Auth;

# ABSTRACT: Auth for Jedi

use strict;
use warnings;

# VERSION

use Import::Into;
use Module::Runtime qw/use_module/;

use B::Hooks::EndOfScope;

sub import {
	my $target = caller;
	on_scope_end {
		$target->can('with')->('Jedi::Plugin::Auth::Role');
	};
	return;
}

1;
__END__
TODO
