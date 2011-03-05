package IRC::Schema::Result::User;

use IRC::Schema::Candy;

table 'Users';

column id => {
   data_type => 'int',
   is_auto_increment => 1,
};

column handle => {
   data_type => 'varchar',
   size => 30,
};

primary_key 'id';

has_many messages => 'IRC::Schema::Result::Message', 'user_id';

unique_constraint [qw( handle )];

1;
