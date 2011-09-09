#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Routine;
use Test::Routine::Util '-all';

with qw(t::lib::LibraryGenerator);

has library => (
    is => 'ro',
    default => sub { $_[0]->fresh_library(4) },
    lazy => 1,
);

sub all (&@) {
  my $p = shift;
  for (@_) { return unless $p->($_) }
  return 1;
}

test "filter" => sub {
  my ($self) = @_;
  my $lib = $self->library;
  my $books = $lib->book_collection;
  ok($books->does("Stick::Role::Collection::CanFilter"));
  my $hemingway = $books->filter(sub { $_->author eq "Hemingway" });
  ok($hemingway->does("Stick::Role::Collection"));
  is($hemingway->count, 2);
  for my $book (@{$hemingway->items}) {
    is ($book->author, "Hemingway");
  }
  for my $book ($hemingway->all) {
    is ($book->author, "Hemingway");
  }
};

test "subfilter" => sub {
  my ($self) = @_;
  my $lib = $self->library;
  my $books = $lib->book_collection;
  my $fat_russian = $books->filter(sub { $_->length > 200 })
      ->filter(sub { $_->author eq "Dostoevsky" });
  ok($fat_russian->does("Stick::Role::Collection"));
  is($fat_russian->count, 1);
};

run_me;
done_testing;
