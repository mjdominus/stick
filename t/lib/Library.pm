package t::lib::Library;
# ABSTRACT: Class for testing HasCollection
use Moose;
use Moose::Util::TypeConstraints qw(role_type);
use MooseX::Types::Moose qw(HashRef Str);

use Data::GUID ();

has by_id => (
  is => 'ro',
  isa => HashRef [ role_type('t::lib::Book') ],
  default => sub { {} },
  traits => [ 'Hash' ],
  handles => {
    store_book => 'set',
  },
);

has guid => (
  is  => 'ro',
  isa => Str,
  init_arg => undef,
  default  => sub { Data::GUID->new->as_string },
);

with (
  'Stick::Role::HasCollection' => {
    item => 'book',
    collection_roles => [ 'Stick::Role::Collection::Pageable',
                          'Stick::Role::Collection::Mutable',
                          'Stick::Role::Collection::CanFilter',
                          't::lib::LibraryExtras',
                         ]});

sub book_array {
  my ($self) = @_;
  return [ values %{$self->by_id} ];
}

sub add_this_book {
  my ($self, $book) = @_;
#  my $book = $arg->{new_item} || confess "Missing new_item argument to add_this_book";
  $self->store_book($book->guid, $book);
}

package Book;
use Moose;
with 't::lib::Book';

1;

