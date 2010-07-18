package DBIx::Class::Candy::Exports;

use strict;
use warnings;

our %methods;
our %aliases;

sub export_methods(\@)        { $methods{scalar caller(1)} = $_[1] }
sub export_method_aliases(\%) { $aliases{scalar caller(1)} = $_[1] }

use Sub::Exporter -setup => {
   exports => [ qw(export_methods export_method_aliases) ],
   groups  => { default => [ qw(export_methods export_method_aliases) ] },
};

1;

