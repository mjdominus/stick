#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Routine;
use Test::Routine::Util '-all';

use t::lib::Library;
use t::lib::Book;

sub all (&@) {
  my $p = shift;
  for (@_) { return unless $p->($_) }
  return 1;
}

sub fresh_library {
  my ($self, $n) = @_;
  $n ||= 0;
  my $lib = t::lib::Library->new();
  for (1 .. $n) {
    $lib->add_this_book($self->next_book());
  }
  die "Couldn't make library with $n books"
      unless @{$lib->book_array} == $n;
  return $lib;
}

test "find_by" => sub {
  my ($self) = @_;
  my $books;
  my $lib = $self->fresh_library(4);

  { my @H = $lib->book_collection->find_by("author", "Hemingway")->all;
    is(@H, 2, "Hemingway 2");
    ok(all { $_->author eq "Hemingway" } @H);
  }
};

run_me;
done_testing;

sub next_book {
  my ($self) = @_;
  my @lines;
  push @lines, $_ while defined($_ = <DATA>) && /\S/;
  chomp @lines;
  my %items = map split(/:\s+/, $_, 2), @lines;
  return Book->new(\%items);
}

__DATA__
author: Hemingway
title: The Sun Also Rises
length: 120

author: Dostoevsky
title: Crime and Punishment
length: 457

author: Dickens
title: Great Expectations
length: 382

author: Hemingway
title: For Whom the Bell Tolls
length: 183
