#!perl -T
use 5.10;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Net::Amazon::Cognito' ) || print "Bail out!\n";
}

diag( "Testing Net::Amazon::Cognito $Net::Amazon::Cognito::VERSION, Perl $], $^X" );
