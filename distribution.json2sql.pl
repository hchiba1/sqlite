#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
use JSON;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM -t TABLE
";

my %OPT;
getopts('t:', \%OPT);

STDOUT->autoflush;

my $TABLE = $OPT{t} || die $USAGE;

my @CONTENT = <>;

# print STDERR "parsing JSON..\n";
my $DATA = decode_json(join("", @CONTENT));

my $LEN = @{$DATA};
# print STDERR "output $LEN entries..\n";
for (my $i=0; $i<$LEN; $i++) {
    my $entry = ${$DATA}[$i];
    my $id = $entry->{"id"};
    my $label = $entry->{"label"};
    my $value = $entry->{"value"};
    my $binId = $entry->{"binId"};
    my $binLabel = $entry->{"binLabel"};
    print "insert into $TABLE (distribution, distribution_label, distribution_value, bin_id, bin_label) values ('$id', '$label', $value, '$binId', '$binLabel');\n";
}
