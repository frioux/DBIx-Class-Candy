package A::Result;

use DBIx::Class::Candy;
use namespace::clean;

table 'awesome';
load_components '+A::Component';
column 'frew';
giant_robot();
1;
