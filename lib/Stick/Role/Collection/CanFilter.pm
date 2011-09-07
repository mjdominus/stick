package Stick::Role::Collection::CanFilter;

use MooseX::Role::Parameterized;
use MooseX::Types::Moose qw(Str);

parameter item_class => (
  is => 'ro',
  isa => Str, # name of class
  required => 1,
);
#    return $p->item_class->get_all_attributes;

role {
  my ($p) = @_;
  with ('Stick::Role::Collection::HasFilters');

  my $item_class      = $p->item_class;

  method filter => sub {
    my ($self, @filters) = @_;

    $self->meta->new_object(
      owner => $self,
      item_array => "items",
      filters => [ @filters ],
     );
  };
};

1;
