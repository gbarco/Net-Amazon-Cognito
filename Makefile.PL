use 5.10;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Net::Amazon::Cognito',
    AUTHOR           => q{Gonzalo Barco <gbarco uy at gmail com, no spaces>},
    VERSION_FROM     => 'lib/Net/Amazon/Cognito.pm',
    ABSTRACT_FROM    => 'lib/Net/Amazon/Cognito.pm',
    LICENSE          => 'gpl, artistic',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.10,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Net-Amazon-Cognito-*' },
);
