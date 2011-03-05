package IRC::Schema::Result;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

__PACKAGE__->load_components('Candy');

sub candy_base() { $_[1] || 'IRC::Schema::Result' }

sub candy_perl_version() { return 10 if $] >= 5.010 }
sub candy_autotable() { 1 }
sub candy_gentable {
   my $self = shift;
   my $ret  = $self->next::method(@_);

   ucfirst $ret
}
1;
