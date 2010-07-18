package DBIx::Class::Candy;

use strict;
use warnings;
use namespace::clean;
require DBIx::Class::Candy::Exports;
use MRO::Compat;

my $inheritor;

sub _generate {
   my ($class, $name) = @_;
   sub { $inheritor->$name(@_) }
}

my @custom_methods;
my %custom_aliases;

my %aliases = (
   # ResultSourceProxy::Table
   column => 'add_columns',
   primary_key => 'set_primary_key'
);

sub _generate_alias {
   my ($class, $name) = @_;
   my $meth = $aliases{$name};
   sub { $inheritor->$meth(@_) }
}

my @methods = (
   # DBIx::Class
   qw(
   load_components
   ),

   # ResultSourceProxy::Table
   qw(
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
   add_unique_constraint
   unique_constraints
   unique_constraint_names
   unique_constraint_columns
   relationships
   relationship_info
   has_relationship
   table
   add_columns
   add_column
   add_relationship
   remove_column
   source_name
),
   #_pri_cols
   #iterator_class
   #set_inherited_ro_instance
   #get_inherited_ro_instance

   # InflateColumn
   qw(),
   # Relationship
   qw(),
   # PK::Auto
   qw(),
   # PK
   qw(),
   # Row
   qw()
);
use Sub::Exporter 'setup_exporter';
setup_exporter({
   exports => [
      (map { $_ => \'_generate' } @methods, @custom_methods),
      (map { $_ => \'_generate_alias' } keys %aliases, keys %custom_aliases),
   ],
   groups  => { default => [ @methods, keys %aliases, keys %custom_aliases ] },
   installer  => sub {
      Sub::Exporter::default_installer @_;
      namespace::clean->import({
         -cleanee => $inheritor,
      })
   },
   collectors => [
      INIT => sub {
         %custom_aliases = ();
         @custom_methods = ();
         $inheritor = $_[1]->{into};

         for (@{mro::get_linear_isa($inheritor)}) {
            if (my $hashref = $DBIx::Class::Candy::Exports::aliases{$_}) {
               %custom_aliases = (%custom_aliases, %{$hashref})
            }
            if (my $arrayref = $DBIx::Class::Candy::Exports::methods{$_}) {
               @custom_methods = (@custom_methods, @{$arrayref})
            }
         }

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
});

1;
