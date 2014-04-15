#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Warnings;

use t::lib::TestUtils;

my $stdout = undef;
my $org = 'Organization'->new(
    name       => 'Catholic Church',
    boss_name  => 'Francis',
    boss_title => 'Pope',
    boss_class => sub { $stdout = 'Hi there!'; return },
    hq_name    => 'Rome',
);

isa_ok( $org, 'Organization' );
$org->boss;
is($stdout, 'Hi there!', 'class code executed');
ok( ! defined($org->boss), 'boss not built' );

done_testing;