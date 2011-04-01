#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 5;
use Test::Mojo;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use_ok('MyApp');

# Test
my $t = Test::Mojo->new(app => 'MyApp');
$t->get_ok('/welcome')->status_is(200)->content_type_is('text/html')
  ->content_like(qr/Mojolicious Web Framework/i);
