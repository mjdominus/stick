#!/usr/bin/env perl
use strict;
use warnings;
use Carp qw(confess croak);
use Test::Fatal;
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
  my $lib = $self->fresh_library(4);

  { my $d = $lib->book_collection->find_one_by("author", "Dostoevsky");
    is($d->author, "Dostoevsky", "Found unique book by Dostoevsky");

    my $u = $lib->book_collection->find_one_by("author", "Rand");
    ok(! defined($u), "No books by Rand");
  }

  like(exception { $lib->book_collection->find_one_by("author", "Hemingway") },
       qr/Found multiple objects/,
       "Multiple books by Hemingway");
};

test "find_one_with" => sub {
  my ($self) = @_;
  my $lib = $self->fresh_library(4);

  { my $d = $lib->book_collection->find_one_with("is_very_long");
    ok($d->length > 400, "one very long book");
  }

  like(exception { $lib->book_collection->find_one_with("is_hardback") },
       qr/Found multiple objects/,
       "Multiple hardbacks");

  like(exception { $lib->book_collection->find_one_without("is_hardback") },
       qr/Found multiple objects/,
       "Multiple non-hardbacks");
};

run_me;
done_testing;

