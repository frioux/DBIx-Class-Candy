package A::Schema::Candy;

use base 'DBIx::Class::Candy';

sub candy_base { 'A::Schema::Result' }

1;
