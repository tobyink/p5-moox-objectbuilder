#!/usr/bin/perl

use strict;
use warnings;
use utf8::all;
use Test::More;# tests => 9;
use Test::FailWarnings;

use t::lib::TestUtils;

my $i;

{
    package HolyMan;
    use Moo;
    has name  => (is => 'ro');
    has title => (is => 'ro');
}

my %org_args = (
    name       => 'Catholic Church',
    boss_name  => 'Francis',
    boss_title => 'Pope',
    boss_class => sub { $i++ % 2 ? 'Pontiff'->new(@_) : 'HolyMan'->new(@_) },
    hq_name    => 'Rome',
);


my $org = 'Organization'->new(
    %org_args
);

my $boss_test = sub {
    plan tests => 2;
    is( $org->boss->name, 'Francis', 'boss name' );
    is( $org->boss->title, 'Pope', 'boss title' );
};

isa_ok( $org->boss, 'HolyMan', 'object class at first' );
subtest 'boss test #1' => $boss_test;
$org->clear_boss;
isa_ok( $org->boss, 'Pontiff', 'object class after clear and build' );
subtest 'boss test #2' => $boss_test;

isa_ok( Organization->new(%org_args)->boss, 'HolyMan',
        'object class of a new object again' );
isa_ok( Organization->new(%org_args)->boss, 'Pontiff',
        'and object class of another new object again' );

done_testing;
