#!/usr/bin/perl

use strict;
use warnings;
use utf8::all;
use Test::More tests => 6;
use Test::FailWarnings;

use t::lib::TestUtils;

{
    package HeadOfOrganization;
    sub new {
        my $class = shift;
        my $args = shift;
        return bless $args, $class;
    }
}

my $org = 'Organization'->new(
    name       => 'Catholic Church',
    boss_name  => 'Francis',
    boss_title => 'Pope',
    boss_class => 'HeadOfOrganization',
    hq_name    => 'Rome',
);

isa_ok( $org->boss, 'HeadOfOrganization' );
isa_ok( $org->headquarters, 'Place' );

my $test_attr_objects = sub {
    plan tests => 3;
    is( $org->boss->{name}, 'Francis', 'boss name' );
    is( $org->boss->{title}, 'Pope', 'boss title' );
    is( $org->headquarters->name, 'Rome', 'HQ name' );
};

subtest 'attribute object properties' => $test_attr_objects;

$org->clear_boss;
$org->clear_headquarters;

ok( ! $org->has_boss, 'boss cleared' );
ok( ! $org->has_headquarters, 'headquarters cleared' );

subtest 'attribute object properties after recreation' => $test_attr_objects;
