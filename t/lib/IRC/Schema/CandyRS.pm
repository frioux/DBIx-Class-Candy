package IRC::Schema::CandyRS;

use base 'DBIx::Class::Candy::ResultSet';

sub base { 'IRC::Schema::ResultSet' }

sub perl_version { return 10 if $] >= 5.010 }

1;

