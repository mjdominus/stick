#!/usr/bin/env perl
use strict;
use warnings;
use Carp qw(confess croak);
use Test::More;
use Test::Routine;
use Test::Routine::Util '-all';

with qw(t::lib::LibraryGenerator);

sub all (&@) {
  my $p = shift;
  for (@_) { return unless $p->($_) }
  return 1;
}

test "find_by" => sub {
  my ($self) = @_;
  my $lib = $self->fresh_library(4);

  { my @H = $lib->book_collection->find_by("author", "Hemingway")->all;
    is(@H, 2, "Hemingway 2");
    ok(all { $_->author eq "Hemingway" } @H);
  }

  { my $d = $lib->book_collection->find_one_by("author", "Dostoevsky");
    is($d->author, "Dostoevsky", "Found unique book by Dostoevsky");

    my $u = $lib->book_collection->find_one_by("author", "Rand");
    ok(! defined($u), "No books by Rand");
  }
};

test "find_with" => sub {
  my ($self) = @_;
  my $lib = $self->fresh_library(4);
  { my @H = $lib->book_collection->find_with("is_hardback")->all;

    my $H = $lib->book_collection->find_with("is_hardback");
    is(@H, 2, "Hardbacks 2");
    ok(all { $_->is_hardback } @H);
  }
};

test "find_one_by" => sub {
  my ($self) = @_;
  pass();
};

test "find_one_with" => sub {
  my ($self) = @_;
  pass();
};

run_me;
done_testing;

