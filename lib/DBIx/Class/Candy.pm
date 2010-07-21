package DBIx::Class::Candy;

use strict;
use warnings;
use namespace::autoclean;
require DBIx::Class::Candy::Exports;
use MRO::Compat;

# ABSTRACT: Sugar for your favorite ORM, DBIx::Class

my $inheritor;

sub _generate {
   my ($class, $name) = @_;
   sub { $inheritor->$name(@_) }
}

my @custom_methods;
my %custom_aliases;

my %aliases = (
   # ResultSourceProxy::Table
   column            => 'add_columns',
   primary_key       => 'set_primary_key',
   unique_constraint => 'add_unique_constraint',
   relationship      => 'add_relationship',
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
   #unique_constraints
   #unique_constraint_names
   #unique_constraint_columns
   #relationships
   #relationship_info
   #has_relationship

   # InflateColumn
   'inflate_column',
   # Relationship
   qw(
   belongs_to
   has_many
   might_have
   has_one
   many_to_many
   ),

   # PK::Auto
   'sequence',
   # PK
   qw(),
   # Row
   qw(
   result_source
   register_column
   )
   #new
   #insert
   #in_storage
   #update
   #delete
   #get_column
   #throw_exception
   #id
   #discard_changes
   #discard_changes ($attrs)
   #get_columns
   #get_dirty_columns
   #make_column_dirty
   #get_inflated_columns
   #set_column
   #set_columns
   #set_inflated_columns
   #copy
   #store_column
   #inflate_result
   #update_or_insert
   #insert_or_update
   #is_changed
   #is_column_changed
   #has_column_loaded
   #get_from_storage
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
         $perl_version = ord $_[$idx + 1];
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

1;

=pod

=head1 SYNOPSIS

 package MyApp::Schema::Result::Artist;

 use DBIx::Class::Candy;

 table 'artists';

 column id => {
   data_type => 'int',
   is_auto_increment => 1,
 };

 column name => {
   data_type => 'varchar',
   size => 25,
   is_nullable => 1,
 };

 primary_key 'id';

 has_many albums => 'A::Schema::Result::Album', 'artist_id';

 1;

=head1 DESCRIPTION

C<DBIx::Class::Candy> is a simple sugar layer for definition of
L<DBIx::Class> results.  Note that it may later be expanded to add sugar
for more C<DBIx::Class> related things.  By default C<DBIx::Class::Candy>:

=over

=item *

turns on strict and warnings

=item *

sets your parent class

=item *

exports a bunch of the package methods that you normally use to define your
L<DBIx::Class> results

=item *

makes a few aliases to make some of the original method names a shorter or
more clear

=back

It assumes a L<DBIx::Class::Core>-like API, but you can tailor it to suit
your needs.

=head1 IMPORT OPTIONS

=head2 -base

 use DBIx::Class::Candy -base => 'MyApp::Schema::Result';

The first thing you can do to customize your usage of C<DBIx::Class::Candy>
is change the parent class.  Do that by using the C<-base> import option.

=head2 -components

 use DBIx::Class::Candy -components => ['FilterColumn'];

C<DBIx::Class::Candy> allows you to set which components you are using at
import time so that the components can define their own sugar to export as
well.  See L<DBIx::Class::Candy::Exports> for details on how that works.

=head2 -perl5

 use DBIx::Class::Candy -perl5 => v10;

I love the new features in Perl 5.10 and 5.12, so I felt that it would be
nice to remove the boiler plate of doing C<< use feature ':5.10' >> and
add it to my sugar importer.  Feel free not to use this.

=head1 IMPORTED SUBROUTINES

Most of the imported subroutines are the same as what you get when you use
the normal interface for result definition: they have the same names and take
the same arguments.  In general write the code the way you normally would,
leaving out the C<< __PACKAGE__-> >> part.  There are some
exceptions though, which brings us to:

=head1 IMPORTED ALIASES

These are merely renamed versions of the functions you know and love.  The idea is
to make your result classes a tiny bit prettier by aliasing some methods.
If you know your C<DBIx::Class> API you noticed that in the L</SYNOPSIS> I used C<column>
instead of C<add_columns> and C<primary_key> instead of C<set_primary_key>.  The old
versions work, this is just nicer.  A list of aliases are as follows:

 column            => 'add_columns',
 primary_key       => 'set_primary_key',
 unique_constraint => 'add_unique_constraint',
 relationship      => 'add_relationship',
