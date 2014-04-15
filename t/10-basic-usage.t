#!/usr/bin/perl

use strict;
use warnings;
use utf8::all;
use Test::Most;
use Test::FailWarnings;


{
    package Person;
    use Moo;
    has name  => (is => 'ro');
    has title => (is => 'ro');
}

{
    package Pontiff;
    use Moo;
    extends qw(Person);
}

{
    package Place;
    use Moo;
    has name  => (is => 'ro');
}

{
    package Organization;
    use Moo;
    use MooX::ObjectBuilder;
    has name => (is => 'ro');
    has boss => (
        predicate => 1,
        is => make_builder(
            'Person' => {
                boss_name   => 'name',
                boss_title  => 'title',
                boss_class  => '__CLASS__',
            },
        )
    );
    has headquarters => (
        predicate => 1,
        is => make_builder(
            sub { 'Place'->new(@_) } => (
                hq_name => 'name',
            ),
        )
    );
}

my $org = 'Organization'->new(
    name       => 'Catholic Church',
    boss_name  => 'Francis',
    boss_title => 'Pope',
    boss_class => 'Pontiff',
    hq_name    => 'Rome',
);

ok( ! $org->has_boss, "Lazy boss" );
ok( ! $org->has_headquarters, "Lazy headquarters" );

isa_ok( $org->boss, "Person" );
isa_ok( $org->boss, "Pontiff" );
isa_ok( $org->headquarters, "Place" );

done_testing;
