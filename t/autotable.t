use strict;
use warnings;
use Test::More;
use Test::Fatal;

use lib 't/lib';
require DBIx::Class::Candy;

subtest v1 => sub { # {{{
   is(
      DBIx::Class::Candy->gen_table('MyApp::Schema::Result::Cat', 1),
      'cats',
      'simple name'
   );

   is(
      DBIx::Class::Candy->gen_table('MyApp::Schema::Result::Traffic::Ticket', 1),
      'traffic_tickets',
      'name with ::'
   );

   is(
      DBIx::Class::Candy->gen_table('MyApp::DB::Result::Dog', 1),
      'dogs',
      'simple no ::Schema'
   );

   like(
      exception {
         DBIx::Class::Candy->gen_table('MyApp::DB::Pal', 1)
      },
      qr(^unrecognized naming scheme! at t/autotable\.t),
      'unknown naming scheme'
   );
};

done_testing;
