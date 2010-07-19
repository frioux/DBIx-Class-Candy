package DBIx::Class::Candy;

use strict;
use warnings;
use namespace::autoclean;
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
use Sub::Exporter 'build_exporter';
my $base;
my $perl_version;
my $components;

my $import = build_exporter({
   exports => [
      (map { $_ => \'_generate' } @methods, @custom_methods),
      (map { $_ => \'_generate_alias' } keys %aliases, keys %custom_aliases),
   ],
   groups  => { default => [ @methods, keys %aliases, keys %custom_aliases ] },
   installer  => sub {
      Sub::Exporter::default_installer @_;
      namespace::autoclean->import(
         -cleanee => $inheritor,
      )
   },
   collectors => [
      INIT => sub {
         my $orig = $_[1]->{import_args};
         $_[1]->{import_args} = [];
         %custom_aliases = ();
         @custom_methods = ();
         $inheritor = $_[1]->{into};

         # inlined from parent.pm
         for ( my @useless = $base ) {
            s{::|'}{/}g;
            require "$_.pm"; # dies if the file is not found
         }

         {
            no strict 'refs';
            # This is more efficient than push for the new MRO
            # at least until the new MRO is fixed
            @{"$inheritor\::ISA"} = (@{"$inheritor\::ISA"} , $base);
         }

         $inheritor->load_components(@{$components});
         for (@{mro::get_linear_isa($inheritor)}) {
            if (my $hashref = $DBIx::Class::Candy::Exports::aliases{$_}) {
               %custom_aliases = (%custom_aliases, %{$hashref})
            }
            if (my $arrayref = $DBIx::Class::Candy::Exports::methods{$_}) {
               @custom_methods = (@custom_methods, @{$arrayref})
            }
         }

         strict->import;
         warnings->import;
      }
   ],
});

sub import {
   my $self = shift;

   $base = 'DBIx::Class::Core';
   $perl_version = undef;
   $components = [];

   my @rest;

   my $skipnext;
   for my $idx ( 0 .. $#_ ) {
      my $val = $_[$idx];

      next unless defined $val;
      if ($skipnext) {
         $skipnext--;
         next;
      }

      if ( $val eq '-base' ) {
         $base = $_[$idx + 1];
         $skipnext = 1;
      } elsif ( $val eq '-perl5' ) {
         $perl_version = $_[$idx + 1];
         $skipnext = 1;
      } elsif ( $val eq '-components' ) {
         $components = $_[$idx + 1];
         $skipnext = 1;
      } else {
         push @rest, $val;
      }
   }

   @_ = ($self, @rest);
   goto $import
}

# < mst> use DBIx::Class::Candy -base => 'Foo', -components => [ 'One', 'Two' ];

1;
