use strict;
use warnings;
use Test::More;
use Test::Deep;

use lib 't/lib';
use IRC::Schema;

use Devel::Dwarn;
subtest Channel => sub { # {{{
   my $result_class = IRC::Schema->resultset('Channel')->result_class;
   isa_ok $result_class, 'IRC::Schema::Result';
   cmp_set [$result_class->columns], [qw(id name network_id)], 'columns get set correctly';

   cmp_deeply $result_class->column_info('name'), {
     data_type => 'varchar',
     size => 100,
   }, 'name metadata set';
   cmp_deeply $result_class->column_info('id'), {
     data_type => 'int',
     is_auto_increment => 1,
   }, 'id metadata set';
   cmp_deeply $result_class->column_info('network_id'), {
     data_type => 'int',
   }, 'network_id metadata set';

   cmp_deeply $result_class->relationship_info('network'), {
     attrs => {
       accessor => "single",
       fk_columns => {
         network_id => 1
       },
       is_foreign_key_constraint => 1,
       undef_on_null_fk => 1
     },
     class => "IRC::Schema::Result::Network",
     cond => {
       "foreign.id" => "self.network_id"
     },
     source => "IRC::Schema::Result::Network"
   }, 'network relationship works';

   cmp_deeply([$result_class->primary_columns], [ 'id' ], 'id gets set to pk');

   cmp_deeply({ $result_class->unique_constraints }, {
     Channels_name => [ 'name' ],
     primary => [ 'id' ],
   }, 'unqiue constraints get set correctly');

   is( $result_class->table, 'Channels', 'table gets set correctly');

   is( $result_class->test_perl_version, 'station', 'perl version gets set from base class') if $] >= 5.010;
}; # }}}

subtest Message => sub { # {{{
   my $result_class = IRC::Schema->resultset('Message')->result_class;
   isa_ok $result_class, 'DBIx::Class::Core';
   ok(!$result_class->isa('IRC::Schema::Result'), 'Not a ::Result');
   cmp_set [$result_class->columns], [qw(id user_id mode_id channel_id value when_said)], 'columns get set correctly';

   cmp_deeply $result_class->column_info('id'), {
     data_type => 'int',
     is_auto_increment => 1,
   }, 'id metadata set';
   cmp_deeply $result_class->column_info('user_id'), {
     data_type => 'int',
   }, 'user_id metadata set';
   cmp_deeply $result_class->column_info('mode_id'), {
     data_type => 'int',
   }, 'mode_id metadata set';
   cmp_deeply $result_class->column_info('channel_id'), {
     data_type => 'int',
   }, 'channel_id metadata set';
   cmp_deeply $result_class->column_info('value'), {
     data_type => 'varchar',
     size      => 100,
   }, 'value metadata set';
   cmp_deeply $result_class->column_info('when_said'), {
     data_type => 'datetime',
   }, 'when_said metadata set';

   cmp_deeply $result_class->relationship_info('user'), {
     attrs => {
       accessor => "single",
       fk_columns => {
         user_id => 1
       },
       is_foreign_key_constraint => 1,
       undef_on_null_fk => 1
     },
     class => "IRC::Schema::Result::User",
     cond => {
       "foreign.id" => "self.user_id"
     },
     source => "IRC::Schema::Result::User"
   }, 'user relationship works';
   cmp_deeply $result_class->relationship_info('channel'), {
     attrs => {
       accessor => "single",
       fk_columns => {
         channel_id => 1
       },
       is_foreign_key_constraint => 1,
       undef_on_null_fk => 1
     },
     class => "IRC::Schema::Result::Channel",
     cond => {
       "foreign.id" => "self.channel_id"
     },
     source => "IRC::Schema::Result::Channel"
   }, 'channel relationship works';
   cmp_deeply $result_class->relationship_info('mode'), {
     attrs => {
       accessor => "single",
       fk_columns => {
         mode_id => 1
       },
       is_foreign_key_constraint => 1,
       undef_on_null_fk => 1
     },
     class => "IRC::Schema::Result::Mode",
     cond => {
       "foreign.id" => "self.mode_id"
     },
     source => "IRC::Schema::Result::Mode"
   }, 'mode relationship works';

   cmp_deeply([$result_class->primary_columns], [ 'id' ], 'id gets set to pk');

   is( $result_class->table, 'Messages', 'table gets set correctly');
}; # }}}

subtest Mode => sub { # {{{
   my $result_class = IRC::Schema->resultset('Mode')->result_class;
   isa_ok $result_class, 'IRC::Schema::Result';
   cmp_set [$result_class->columns], [qw(id name code)], 'columns get set correctly';

   cmp_deeply $result_class->column_info('id'), {
     data_type => 'int',
     is_auto_increment => 1,
   }, 'id metadata set';
   cmp_deeply $result_class->column_info('name'), {
     data_type => 'varchar',
     size => 30,
   }, 'name metadata set';
   cmp_deeply $result_class->column_info('code'), {
     data_type => 'char',
     size => 1,
   }, 'code metadata set';

   cmp_deeply([$result_class->primary_columns], [ 'id' ], 'id gets set to pk');

   cmp_deeply({ $result_class->unique_constraints }, {
     Modes_name => [ 'name' ],
     Modes_code => [ 'code' ],
     primary => [ 'id' ],
   }, 'unqiue constraints get set correctly');

   is( $result_class->table, 'Modes', 'table gets set correctly');
}; # }}}

subtest Network => sub { # {{{
   my $result_class = IRC::Schema->resultset('Network')->result_class;
   isa_ok $result_class, 'IRC::Schema::Result';
   cmp_set [$result_class->columns], [qw(id name)], 'columns get set correctly';

   cmp_deeply $result_class->column_info('id'), {
     data_type => 'int',
     is_auto_increment => 1,
   }, 'id metadata set';
   cmp_deeply $result_class->column_info('name'), {
     data_type => 'varchar',
     size => 100,
   }, 'name metadata set';

   cmp_deeply([$result_class->primary_columns], [ 'id' ], 'id gets set to pk');

   cmp_deeply({ $result_class->unique_constraints }, {
     Networks_name => [ 'name' ],
     primary => [ 'id' ],
   }, 'unqiue constraints get set correctly');

   is( $result_class->table, 'Networks', 'table gets set correctly');
}; # }}}

subtest User => sub { # {{{
   my $result_class = IRC::Schema->resultset('User')->result_class;
   isa_ok $result_class, 'IRC::Schema::Result';
   cmp_set [$result_class->columns], [qw(id handle)], 'columns get set correctly';

   cmp_deeply $result_class->column_info('id'), {
     data_type => 'int',
     is_auto_increment => 1,
   }, 'id metadata set';
   cmp_deeply $result_class->column_info('handle'), {
     data_type => 'varchar',
     size => 30,
   }, 'handle metadata set';

   cmp_deeply $result_class->relationship_info('messages'), {
     attrs => {
       accessor => "multi",
       cascade_copy => 1,
       cascade_delete => 1,
       join_type => "LEFT"
     },
     class => "IRC::Schema::Result::Message",
     cond => {
       "foreign.user_id" => "self.id"
     },
     source => "IRC::Schema::Result::Message"
   }, 'messages relationship works';

   cmp_deeply([$result_class->primary_columns], [ 'id' ], 'id gets set to pk');

   cmp_deeply({ $result_class->unique_constraints }, {
     users_handle => [ 'handle' ],
     primary => [ 'id' ],
   }, 'unqiue constraints get set correctly');

   is( $result_class->table, 'users', 'table gets set correctly');
}; # }}}


done_testing;

# vim: foldmethod=marker
