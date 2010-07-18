use strict;
use warnings;
use Test::More;

use lib 't/lib';
use A::Result;

isa_ok 'A::Result', 'DBIx::Class::Core';

is( 'A::Result'->table, 'awesome', 'table set correctly' );
my @cols = 'A::Result'->columns;
is( $cols[0], 'frew', 'column set correctly' );

done_testing;
