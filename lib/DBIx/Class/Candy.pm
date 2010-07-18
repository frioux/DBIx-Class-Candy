package DBIx::Class::Candy;

use strict;
use warnings;

my $inheritor;

sub _generate_simple {
   my ($class, $name) = @_;
   sub { $inheritor->result_source_instance->$name(@_) }
}

sub _generate_complex {
   my ($class, $name) = @_;
   require DBIx::Class::ResultSourceProxy::Table;
   my $fn = DBIx::Class::ResultSourceProxy::Table->can($name);
   sub { $inheritor->$fn(@_) }
}

my @simple_methods;
my @complex_methods;

BEGIN {
   @simple_methods = qw(
      resultset_class
      result_class
      source_info
      resultset_attributes
      has_column
      column_info
      column_info_from_storage
      columns
      remove_columns
      set_primary_key
      primary_columns
      _pri_cols
      add_unique_constraint
      unique_constraints
      unique_constraint_names
      unique_constraint_columns
      relationships
      relationship_info
      has_relationship
   );

   @complex_methods = qw(
      table
      add_columns
      add_column
      add_relationship
      remove_column
      iterator_class
      set_inherited_ro_instance
      get_inherited_ro_instance
      source_name
   );
}

use Sub::Exporter -setup => {
   exports => [
      (map { $_ => \'_generate_complex' } @complex_methods),
      (map { $_ => \'_generate_simple' } @simple_methods)
   ],
   groups  => { default => [ @simple_methods, qw(add_columns table) ] },
   collectors => [
      INIT => sub {
         $inheritor = $_[1]->{into};

         # inlined from parent.pm
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
