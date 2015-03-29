#!perl -T

use Test::More tests => 1;

BEGIN
{
	use_ok( 'WebService::DataDog::Host' );
}

diag( "Testing WebService::DataDog::Host $WebService::DataDog::VERSION, Perl $], $^X" );
