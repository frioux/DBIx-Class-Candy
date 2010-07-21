use strict;
use warnings;
use Test::More;

use lib 't/lib';
use A::Schema;
use A::Schema::Result::Album;

my $result_class =A::Schema->resultset('Album')->result_class;
isa_ok $result_class, 'DBIx::Class::Core';

is( $result_class->table, 'albums', 'table set correctly' );
my @cols = $result_class->columns;
is( $cols[0], 'id', 'id column set correctly' );
is( $cols[1], 'name', 'name column set correctly' );
A::Schema::Result::Album::test_strict;

done_testing;
