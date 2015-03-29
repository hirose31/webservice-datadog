package WebService::DataDog::Host;

use strict;
use warnings;

use base qw( WebService::DataDog );
use Carp qw( carp croak );
use Data::Dumper;
use Try::Tiny;


=head1 NAME

WebService::DataDog::Host - Interface to Host functions in DataDog's API.

=head1 VERSION

Version 1.0.0

=cut

our $VERSION = '1.0.0';


=head1 SYNOPSIS

This module allows you interact with the host endpoint of the DataDog API.

Used to mute/unmute alerting on hosts


=head1 METHODS

=head2 mute()

Mute alerting on specified host.
	
	my $host = $datadog->build('Host');
	$host->mute(
		hostname => $hostname, # Mute alerts on this host
		end      => $end_time, # Optional - default None
		override => $override, # Optional - default False
		#If true and the host is already muted, will overwrite existing end on the host.
	);
	
	Example:
	$host->mute(
		hostname => 'host.example.com'
	);
	
Parameters:

=over 4

=item * hostname

Required. Host for which to mute alerts.

=item * end

Optional. POSIX/Unix/Epoch timestamp when to unmute host. If omitted, host will
be muted until explicitly unmuted.

=item * override

Optional. If true and the host is already muted, will overwrite existing end
on the host.


=back


=cut

sub mute
{
	my ( $self, %args ) = @_;
	my $verbose = $self->verbose();
	
	# Check for mandatory parameters
	foreach my $arg ( qw( hostname ) )
	{
		croak "ERROR - Argument '$arg' is required for mute()."
			if !defined( $args{$arg} ) || ( $args{$arg} eq '' );
	}
	
	if ( defined $args{'end'} )
	{
		if ( !Data::Validate::Type::is_number( $args{'end'}, postive => 1 ) )
		{
			croak "ERROR - invalid 'end' value. Must be a number (unix/epoch time).";
		}
		
	}

	my $url = $WebService::DataDog::API_ENDPOINT . 'host';
	
	my $data = {
		hostname => $args{'hostname'},
	};
	
	my $response = $self->_send_request(
		method => 'POST',
		url    => $url,
		data   => $data,
	);
	
	if ( !defined($response) )
	{
		croak "Fatal error. No response";
	}
	
	print "Response: ", Dumper($response);
	return $response;
}


=head2 unmute()

Unmute alerting on specified host.
	
	my $host = $datadog->build('Host');
	$host->unmute(
		hostname => $hostname, # Unmute alerts on this host
	);
	
	Example:
	$host->unmute(
		hostname => 'host.example.com'
	);
	
Parameters:

=over 4

=item * hostname

Required. Host for which to mute alerts.

=back


=cut

sub unmute
{
	my ( $self, %args ) = @_;
	my $verbose = $self->verbose();
	
	# Check for mandatory parameters
	foreach my $arg ( qw( hostname ) )
	{
		croak "ERROR - Argument '$arg' is required for unmute()."
			if !defined( $args{$arg} ) || ( $args{$arg} eq '' );
	}
	
	if ( defined $args{'end'} )
	{
		if ( !Data::Validate::Type::is_number( $args{'end'}, postive => 1 ) )
		{
			croak "ERROR - invalid 'end' value. Must be a number (unix/epoch time).";
		}
		
	}

	my $url = $WebService::DataDog::API_ENDPOINT . 'host';
	
	my $data = {
		hostname => $args{'hostname'},
	};
	
	my $response = $self->_send_request(
		method => 'POST',
		url    => $url,
		data   => $data,
	);
	
	if ( !defined($response) )
	{
		croak "Fatal error. No response";
	}
	
	print "Response: ", Dumper($response);
	return $response;
}


1;
