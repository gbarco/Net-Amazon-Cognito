package Net::Amazon::Cognito;

use v5.10.0;
use strict;
use warnings FATAL => 'all';
use Carp;
use Net::Amazon::Signature::V4;

=head1 NAME

Net::Amazon::Cognito - The great new Net::Amazon::Cognito!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Net::Amazon::Cognito;

    my $foo = Net::Amazon::Cognito->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

=head1 CONSTRUCTOR

=head2 new( $region, $access_key_id, $secret )

=cut

sub new {
	my ( $class, $region, $access_key_id, $secret ) = @_;

	croak "no region specified" unless $region;
	croak "no access key specified" unless $access_key_id;
	croak "no secret specified" unless $secret;

	my $self = {
		region => $region,
		# be well behaved and tell who we are
		ua     => LWP::UserAgent->new( agent=> __PACKAGE__ . '/' . $VERSION ),
		sig    => Net::Amazon::Signature::V4->new( $access_key_id, $secret, $region, 'cognito-identity' ),
	};
	return bless $self, $class;
}

=head2 Internal Functions

=head3 _send_receive
Simplify notation, crafts a request, sends requests and carp on errors.

=head3 _craft_request
Simplify header definition completing provided headers with required headers.

=head3 _send_request
Send requests, decodes and carps on errors.

=cut

sub _send_receive {
	my $self = shift;
	my $req = $self->_craft_request( @_ );
	return $self->_send_request( $req );
}

sub _craft_request {
	my ( $self, $method, $url, $header, $content ) = @_;
	my $host = 'cognito-identity.'.$self->{region}.'.amazonaws.com';
	my $total_header = [
		'Version' => '2014-06-30',
		'Host' => $host,
		'X-Amz-Date' => POSIX::strftime( '%Y%m%dT%H%M%SZ', gmtime ),
		$header ? @$header : ()
	];
	my $req = HTTP::Request->new( $method => "https://$host$url", $total_header, $content);
	my $signed_req = $self->{sig}->sign( $req );
	return $signed_req;
}

sub _send_request {
	my ( $self, $req ) = @_;
	my $res = $self->{ua}->request( $req );
	if ( $res->is_error ) {
		# try to decode Glacier error
		eval {
			my $error = decode_json( $res->decoded_content );
			carp sprintf 'Non-successful response: %s (%s)', $res->status_line, $error->{code};
			carp decode_json( $res->decoded_content )->{message};
		};
		if ( $@ ) {
			# fall back to reporting ua errors
			carp sprintf "[%d] %s %s\n", $res->code, $res->message, $res->decoded_content;
		}
	}
	return $res;
}

=head1 AUTHOR

Gonzalo Barco, C<< <gbarco uy at gmail com, no spaces> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-amazon-cognito at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Amazon-Cognito>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Amazon::Cognito

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Amazon-Cognito>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Amazon-Cognito>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Amazon-Cognito>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-Amazon-Cognito/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Gonzalo Barco.

This program is released under the following license: gpl, artistic

=cut

1; # End of Net::Amazon::Cognito
