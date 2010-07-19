package A::Result;

use DBIx::Class::Candy
   -perl5 => v10,
   -components => ['+A::Component'],
   -base => 'DBIx::Class::Core',
   ;

table 'awesome';
column 'frew';
giant_robot();
1;
