package IRC::Schema::Result::Message;

use DBIx::Class::Candy -base => 'IRC::Schema::Result';

table 'Messages';

column id => {
   data_type => 'int',
   is_auto_increment => 1,
};

column user_id => {
   data_type => 'int',
};

column mode_id => {
   data_type => 'int',
};

column channel_id => {
   data_type => 'int',
};

column value => {
   data_type => 'varchar',
   size      => 100,
};

column when_said => {
   data_type => 'datetime',
};

primary_key 'id';

belongs_to user => 'IRC::Schema::Result::User', 'user_id';
belongs_to mode => 'IRC::Schema::Result::Mode', 'mode_id';
belongs_to channel => 'IRC::Schema::Result::Channel', 'channel_id';

1;

