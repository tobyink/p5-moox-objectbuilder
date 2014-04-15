#!/usr/bin/perl

use strict;
use warnings;
use utf8::all;
use Test::More tests => 4;
use Test::Exception;
use Test::FailWarnings;

use t::lib::TestUtils;

sub test_org_object {

    my %args = @_;

    my $org = 'Organization'->new(%args);

    plan tests => 7;

    ok( ! $org->has_boss, 'Lazy boss' );
    ok( ! $org->has_headquarters, 'Lazy headquarters' );

    isa_ok( $org->boss, 'Person' );
    isa_ok( $org->headquarters, 'Place' );

    is( $org->boss->name, $args{boss_name}, 'boss name' );
    is( $org->boss->title, $args{boss_title}, 'boss title' );
    is( $org->headquarters->name, $args{hq_name}, 'HQ name' );

};

subtest 'empty attr values' => sub {
    test_org_object(
        name       => '',
        boss_name  => '',
        boss_title => '',
        boss_class => 'Pontiff',
        hq_name    => '',
    );
};

subtest 'undef boss class' => sub {
    test_org_object(
        name       => 'Catholic Church',
        boss_name  => 'Francis',
        boss_title => 'Pope',
        boss_class => undef,
        hq_name    => 'Rome',
    );
};

subtest 'empty boss class' => sub {

    my $org;
    lives_ok {
        $org = Organization->new(
            name       => 'Catholic Church',
            boss_name  => 'Francis',
            boss_title => 'Pope',
            boss_class => '',
            hq_name    => 'Rome',
        )
    } 'org created with empty boss class';

    throws_ok { $org->boss }
        qr/^Can't call method "new" without a package or object/,
        'error on accessing boss with empty class';

};

subtest 'attr values 0' => sub {
    test_org_object(
        name       => 0,
        boss_name  => 0,
        boss_title => 0,
        boss_class => 'Pontiff',
        hq_name    => 0,
    );
};
