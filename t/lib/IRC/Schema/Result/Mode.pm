package IRC::Schema::Result::Mode;

use IRC::Schema::Candy;

primary_column id => {
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

unique_constraint [qw( name )];
unique_constraint [qw( code )];

1;
