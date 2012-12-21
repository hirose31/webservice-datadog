#!perl -T

use strict;
use warnings;

use Data::Dumper;

use Data::Validate::Type;
use Test::Exception;
use Test::More;

use WebService::DataDog;


eval 'use DataDogConfig';
$@
	? plan( skip_all => 'Local connection information for DataDog required to run tests.' )
	: plan( tests => 8 );

my $config = DataDogConfig->new();

# Create an object to communicate with DataDog
my $datadog = WebService::DataDog->new( %$config );
ok(
	defined( $datadog ),
	'Create a new WebService::DataDog object.',
);


my $dashboard_obj = $datadog->build('Dashboard');
ok(
	defined( $dashboard_obj ),
	'Create a new WebService::DataDog::Dashboard object.',
);
my $response;

lives_ok(
	sub
	{
		$response = $dashboard_obj->get_all_dashboards();
	},
	'Request list of all dashboards.',
);

ok(
	Data::Validate::Type::is_hashref( $response ),
	'Retrieve response.',
) || diag( explain( $response ) );

ok(
	defined( $response->{'dashes'} ),
	'We have a "dashes" block in the response.',
);

ok(
	Data::Validate::Type::is_arrayref( $response->{'dashes'} ),
	'"dashes" block is an arrayref.',
);

ok(
	open( FILE, '>', 'webservice-datadog-dashboard-dashid.tmp'),
	'Open temp file to store dashboard ids'
);

# Print first ID number to a text file, to use in other tests
my $first_dash_id = defined $response->{'dashes'}->[0] && $response->{'dashes'}->[0]->{'id'}
 ? $response->{'dashes'}->[0]->{'id'}
 : '';
print FILE $first_dash_id;

ok(
	close FILE,
	'Close temp file'
);
