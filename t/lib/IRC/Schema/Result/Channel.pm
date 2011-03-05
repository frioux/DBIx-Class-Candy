package IRC::Schema::Result::Channel;

use DBIx::Class::Candy -base => 'IRC::Schema::Result';

table 'Channels';

column id => {
   data_type => 'int',
   is_auto_increment => 1,
};

column name => {
   data_type => 'varchar',
   size      => 100,
};

column network_id => {
   data_type => 'int',
};

primary_key 'id';

belongs_to network => 'IRC::Schema::Result::Network', 'network_id';
unique_constraint [qw( name )];

1;

