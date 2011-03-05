package IRC::Schema::Result::Mode;

use DBIx::Class::Candy -base => 'IRC::Schema::Result';

table 'Modes';

column id => {
   data_type         => 'int',
   is_auto_increment => 1,
};

column name => {
   data_type => 'varchar',
   size      => 30,
};

column code => {
   data_type => 'char',
   size      => '1',
};

primary_key 'id';

unique_constraint [qw( name )];
unique_constraint [qw( code )];

1;
