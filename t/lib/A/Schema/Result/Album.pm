package A::Schema::Result::Album;

use DBIx::Class::Candy -base => 'A::Schema::Result';

table 'albums';

column id => {
   data_type => 'int',
   is_auto_increment => 1,
   is_numeric => 1,
};

column name => {
   data_type => 'varchar',
   size => 25,
   is_nullable => 1,
};

column artist_id => {
   data_type => 'int',
   is_nullable => 0,
};

primary_key 'id';

has_many songs => 'A::Schema::Result::Song', 'album_id';

1;

