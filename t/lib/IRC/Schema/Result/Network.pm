package IRC::Schema::Result::Network;

use IRC::Schema::Result;

__PACKAGE__->add_columns( name => {
   data_type => 'varchar',
   size      => 100,
});

primary_column id => {
   data_type => 'int',
   is_auto_increment => 1,
};

unique_constraint [qw( name )];

1;

