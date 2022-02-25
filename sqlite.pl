#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
use DBI;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM
";

my %OPT;
getopts('ls:F:L:C:t:k:v:qc', \%OPT);

if (!@ARGV) {
    print STDERR $USAGE;
    exit 1;
}
my ($DB) = @ARGV;

my $QUERY;
if ($OPT{l}) {
    $QUERY = "select name from sqlite_master where type='table'";
} elsif ($OPT{s}) {
    system "echo '.schema $OPT{s}' | sqlite3 $DB";
    exit;
} elsif ($OPT{C}) {
    $QUERY = "select count(*) from $OPT{C}";
    if ($OPT{k} && $OPT{v}) {
        $QUERY .= " where $OPT{k} = '$OPT{v}'";
    }
} elsif ($OPT{F}) {
    $QUERY = "select * from $OPT{F}";
    if ($OPT{k} && $OPT{v}) {
        $QUERY .= " where $OPT{k} = '$OPT{v}'";
    }
} elsif (-t) {
    $QUERY = "select name from sqlite_master where type='table'";
} else {
    $QUERY = <STDIN>;
}
if ($OPT{L}) {
    $QUERY .= " limit $OPT{L}";
}

if ($OPT{q}) {
    print $QUERY, "\n";
    exit;
}

if ($OPT{c}) {
    system "echo '$QUERY' | sqlite3 $DB";
    exit;
}

my $dbh = DBI->connect("dbi:SQLite:dbname=$DB");
my $sth = $dbh->prepare($QUERY);
$sth->execute();
while (my @row = $sth->fetchrow_array) {
    print $row[0];
    for (my $i=1; $i<@row; $i++) {
        if (defined $row[$i]) {
            print "\t", $row[$i];
        } else {
            print "\t";
        }
    }
    print "\n";
}
$sth->finish;
$dbh->disconnect;