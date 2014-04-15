#!/usr/bin/perl

use strict;
use warnings;
use utf8::all;
use Test::Most tests => 9;
use Test::FailWarnings;

use t::lib::TestUtils;

my $org = 'Organization'->new(
    name       => 'Catholic Church',
    boss_name  => 'Francis',
    boss_title => 'Pope',
    boss_class => 'Pontiff',
    hq_name    => 'Rome',
);

ok( ! $org->has_boss, 'Lazy boss' );
ok( ! $org->has_headquarters, 'Lazy headquarters' );

isa_ok( $org->boss, 'Person' );
isa_ok( $org->boss, 'Pontiff' );
isa_ok( $org->headquarters, 'Place' );

my $test_attr_objects = sub {
    is( $org->boss->name, 'Francis', 'boss name' );
    is( $org->boss->title, 'Pope', 'boss title' );
    is( $org->headquarters->name, 'Rome', 'HQ name' );
};

subtest 'attribute object properties' => sub {  $test_attr_objects->() };

$org->clear_boss;
$org->clear_headquarters;

ok( ! $org->has_boss, 'boss cleared' );
ok( ! $org->has_headquarters, 'headquarters cleared' );

subtest 'attribute object properties after recreation' => sub {  $test_attr_objects->() };
