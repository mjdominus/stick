package t::lib::LibraryGenerator;
use strict;
use warnings;
use Carp qw(confess croak);
use Moose::Role;
use t::lib::Book;
use t::lib::Library;

has books => (
  isa => 'ArrayRef',
  is => 'ro',
  default => sub { [] },
  traits => [ 'Array' ],
  handles => { add_book => 'push', no_books => 'is_empty' },
);

sub fresh_library {
  my ($self, $n) = @_;
  $self->_load_books if $self->no_books;

  my $c = my @books = @{$self->books};
  croak "Library only has $c books" unless $c >= $n;

  my $lib = t::lib::Library->new();
  for (0 .. $n-1) {
    $lib->add_this_book($books[$_]);
  }
  return $lib;
}

sub _load_books {
  my ($self) = @_;
  while (my $book = $self->_next_book()) {
    $self->add_book($book);
  }
}

sub _next_book {
  my ($self) = @_;
  my @lines;
  push @lines, $_ while defined($_ = <DATA>) && /\S/;
  return unless @lines;
  chomp @lines;
  my %items = map split(/:\s+/, $_, 2), @lines;
  return Book->new(\%items);
}

1;

__DATA__
author: Hemingway
title: The Sun Also Rises
length: 120
binding: paper

author: Dostoevsky
title: Crime and Punishment
length: 457
binding: leather

author: Dickens
title: Great Expectations
length: 382
binding: cloth

author: Hemingway
title: For Whom the Bell Tolls
length: 183
binding: paper
