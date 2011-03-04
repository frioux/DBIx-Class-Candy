use strict;
use warnings;
use Test::More;

use lib 't/lib';
use A::Schema;
use A::Schema::Result::Album;

my $result_class = A::Schema->resultset('Album')->result_class;
isa_ok $result_class, 'DBIx::Class::Core';

is( $result_class->table, 'albums', 'table set correctly' );
my @cols = $result_class->columns;
is( $cols[0], 'id', 'id column set correctly' );
is( $cols[1], 'name', 'name column set correctly' );
A::Schema::Result::Album::test_strict;

ok( !$result_class->can('column'), 'namespace gets cleaned');

my $artist_result = A::Schema->resultset('Artist')->result_class;
isa_ok( $artist_result, 'A::Schema::Result');

done_testing;
