package IRC::Schema::Candy;

use base 'DBIx::Class::Candy';

sub candy_base() { $_[1] || 'IRC::Schema::Result' }

sub candy_perl_version() { return 10 if $] >= 5.010 }
sub candy_autotable() { 'v1' }
sub candy_gentable {
   my $self = shift;
   my $ret  = $self->next::method(@_);

   ucfirst $ret
}

1;
