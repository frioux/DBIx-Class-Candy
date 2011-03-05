package IRC::Schema::Result::Network;

use DBIx::Class::Candy -base => 'IRC::Schema::Result';

table 'Networks';

primary_column id => {
   data_type => 'int',
   is_auto_increment => 1,
};

column name => {
   data_type => 'varchar',
   size      => 100,
};

unique_constraint [qw( name )];

1;

