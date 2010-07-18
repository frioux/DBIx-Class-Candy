package DBIx::Class::Candy;

use strict;
use warnings;
require parent;

sub _generate_method {
   my $foo = scalar caller(3);
   my ($class, $name) = @_;
   sub { $foo->result_source_instance->$name(@_) }
}

use Sub::Exporter -setup => {
   exports => [
      itable => sub {
         my $foo = scalar caller(3);
         warn $foo;
         sub { $foo->table(@_) }
      },
      map { $_ => \'_generate_method' }
      qw(add_columns)
   ],
   groups  => { default => [ qw(add_columns itable) ] },
   collectors => [
      INIT => sub {
         my $inheritor = $_[1]->{into};

         require "DBIx/Class/Core.pm"; # dies if the file is not found
         {
            no strict 'refs';
            # This is more efficient than push for the new MRO
            # at least until the new MRO is fixed
            @{"$inheritor\::ISA"} = (@{"$inheritor\::ISA"} , 'DBIx::Class::Core');
         }

         strict->import;
         warnings->import;
      }
   ],
};


1;
