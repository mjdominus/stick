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

  method single => sub {
    my ($self, $msg) = @_;
    my (@items) = $self->all;
    confess $msg
      // sprintf("Found multiple objects in collection '%s', expected at most one",
                 $self->collection_name)
        if @items > 1;
    return $items[0];
  };

  method find_by => sub {
    my ($self, $attr, $val) = @_;
    return $self->filter(sub { $_->$attr eq $val });
  };

  method find_with => sub {
    my ($self, $attr) = @_;
    return $self->filter(sub { $_->$attr });
  };

  method find_one_with => sub {
    my ($self, $attr, $msg) = @_;
    return $self->find_with($attr)->single($msg);
  };

  method find_without => sub {
    my ($self, $attr) = @_;
    return $self->filter(sub { not $_->$attr });
  };

  method find_one_without => sub {
    my ($self, $attr, $msg) = @_;
    return $self->find_without($attr)->single($msg);
  };

  method find_one_by => sub {
    my ($self, $attr, $val, $msg) = @_;
    return $self->find_by($attr, $val)->single($msg);
  };
};

1;
