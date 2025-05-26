#!/usr/bin/perl
# -*-cperl-*-
## Compute per-text frequencies of features extracted with CQP queries.
## See the associated CQP script template for further instructions.
## (C) 2021 Stefan Evert
$| = 1;

use strict;
use warnings;

die "Usage:  cqp -c -f script.txt | perl featex.perl feature_matrix.tsv\n" 
  unless @ARGV == 1;
our $Outfile = shift @ARGV;

chomp($_ = <STDIN>);
die "Error: you must run CQP in child mode (-c).\n(expected CQP version number, but got: $_)\n"
  unless /^CQP version (3\.(\d+)\.(\d+))$/;
my $version_string = $1;
my $version = 3 + $2 / 1e3 + $3 / 1e6; # e.g. 3.004013 = 3.4.13

warn "Warning: CQP version $version_string may be too old, please consider upgrading.\n"
  unless $version >= 3.004010;

## global variables
our @TextID = ();  # list of text IDs
our %TextID = ();  # hash for duplicate checks & validation
our @Feature = (); # list of features;
our %F = ();       # feature counts: $F{$feature}{$text_id} = $freq
our $EOL = "-::-EOL-::-"; # CQP end-of-output marker

## first feature must be text regions + IDs (as "n_token")
chomp($_ = <STDIN>);
die "Error: first feature must be token counts 'n_token'.\n(got: $_)\n"
  unless $_ eq "=====TOKENS n_token";
push @Feature, "n_token";
my $n_token = 0;

while (<STDIN>) {
  chomp;
  last if $_ eq $EOL;
  my @fields = split /\t/;
  die "Format error: expected 3 TAB-delimited fields, but got: $_\n" unless @fields == 3;
  my ($start, $end, $id) = @fields;
  ## don't check for duplicate text IDs in case we're extracting from a subcorpus of sub-text regions
  ## die "Error: duplicate text ID '$id'\n" if $TextID{$id};
  push @TextID, $id unless $TextID{$id};
  $TextID{$id} = 1;
  $F{"n_token"}{$id} += $end - $start + 1; # token count for this text (or add up counts for sub-text regions)
  $n_token += $end - $start + 1;
}
die "Error: missing end-of-output marker\n" unless $_ eq $EOL;

printf "%d texts, %.1fM tokens\n", 0 + @TextID, $n_token / 1e6;

## now process all further features
while (<STDIN>) {
  chomp;
  die "Error: expected feature declaration, but got: $_\n"
    unless /^=====(TOKENS|COUNTS)\s+(\S+)$/;
  my $is_count = ($1 eq "COUNTS");
  my $feature = $2;
  die "Error: duplicate feature name '$feature'.\n" if $F{$feature};
  printf " - feature (%1.1s): %s ... ", $1, $feature;
  push @Feature, $feature;

  my $n_items = 0;
  if ($is_count) {
    ## pre-counted per-text frequencies
    while (<STDIN>) {
      chomp;
      last if $_ eq $EOL;
      my @fields = split /\t/;
      die "Format error: expected 2 TAB-delimited fields, but got: $_\n" unless @fields == 2;
      my ($id, $n) = @fields;
      die "Error: unknown text ID '$id'.\n" unless $TextID{$id};
      die "Error: duplicate entry for text ID '$id'.\n" if $F{$feature}{$id};
      $F{$feature}{$id} = $n;
      $n_items += $n;
    }
    die "Error: missing end-of-output marker\n" unless $_ eq $EOL; 
  }
  else {
    ## individual occurrences of feature
    while (<STDIN>) {
      chomp;
      last if $_ eq $EOL;
      my @fields = split /\t/;
      die "Format error: expected 3 TAB-delimited fields, but got: $_\n" unless @fields == 3;
      my ($start, $end, $id) = @fields;
      die "Error: unknown text ID '$id'.\n" unless $TextID{$id};
      $F{$feature}{$id}++;
      $n_items++;
    }
    die "Error: missing end-of-output marker\n" unless $_ eq $EOL; 
  }

  printf "%d items\n", $n_items;
}

## save feature matrix to .tsv file
open(FH, ">", $Outfile) or die "Can't write output file '$Outfile': $!";
print "Saving feature matrix ... ";
print FH join("\t", "id", @Feature), "\n";
foreach my $id (@TextID) {
  print FH $id;
  foreach my $feature (@Feature) {
    print FH "\t", ($F{$feature}{$id} || 0);
  }
  print FH "\n";
}
close(FH);
printf "%s (%.1f MB)\n", $Outfile, (-s $Outfile) / 1e6;
