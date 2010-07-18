use strict;
use warnings;
use Test::More;

use lib 't/lib';
use A::Result;

isa_ok 'A::Result', 'DBIx::Class::Core';

done_testing;
