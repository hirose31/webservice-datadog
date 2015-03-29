#!perl -T

use strict;
use warnings;

use Data::Dumper;

use Data::Validate::Type;
use Test::Exception;
use Test::Most 'bail';
#use Test::FailWarnings -allow_deps => 1;

use WebService::DataDog;


eval 'use DataDogConfig';
$@
	? plan( skip_all => 'Local connection information for DataDog required to run tests.' )
	: plan( tests => 7 );

my $config = DataDogConfig->new();

# Create an object to communicate with DataDog
my $datadog = WebService::DataDog->new( %$config );
ok(
	defined( $datadog ),
	'Create a new WebService::DataDog object.',
);


my $host_obj = $datadog->build('Host');
ok(
	defined( $host_obj ),
	'Create a new WebService::DataDog::Host object.',
);
my $response;


throws_ok(
	sub
	{
		$response = $host_obj->mute();
	},
	qr/Argument.*required/,
	'Dies on missing required argument.',
);

lives_ok(
	sub
	{
		$response = $host_obj->mute( hostname => 'taz04-macbook-pro' );
	},
	'Mute test Host.',
);

ok(
	defined( $response ),
	'Response was received.'
);

ok(
	Data::Validate::Type::is_hashref( $response ),
	'Response is an hashref.',
) || diag explain $response;

ok (
	exists $response->{'hostname'},
	'Response contains specified hostname.',
) || diag explain $response;
