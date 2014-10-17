use strict;
use warnings;
use Test::More;
use Test::Fatal;

use lib 't/lib', 't/lib2';

ok(
   exception {
      require IRC::Schema::Result::User;
      require IRC::Schema::Result::Message;
      require IRC::Schema::Result::Foo;
      require IRC::Schema::Result::Bar;
   },
   'get exception as expected',
);

done_testing;
