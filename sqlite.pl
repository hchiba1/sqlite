#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
use DBI;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM
-F TABLE: FROM TABLE
-L NUM: LIMIT NUM
-C: count
-k VAR: WHERE VAR=VAL
-v VAL: HHERE VAR=VAL
-s TABLE: schema of TABLE
-H: omit header line
-l: list mode
-c: column mode
-q: show query and quit
";

my %OPT;
getopts('F:L:Ck:v:s:Hlcq', \%OPT);

if (!@ARGV) {
    print STDERR $USAGE;
    exit 1;
}
my ($DB) = @ARGV;

my $QUERY;
my $USE_SQLITE3 = 1;
if ($OPT{s}) {
    $QUERY = ".schema $OPT{s}";
} elsif ($OPT{F}) {
    my $target = "*";
    if ($OPT{C}) {
        $USE_SQLITE3 = 0;
        $target = "count(*)";
    }
    $QUERY = "select ${target} from $OPT{F}";
    if ($OPT{k} && $OPT{v}) {
        $QUERY .= " where $OPT{k} = '$OPT{v}'";
    }
} elsif (-t) {
    $USE_SQLITE3 = 0;
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

if ($USE_SQLITE3) {
    open(PIPE, "| sqlite3 $DB") || die;
    if ($OPT{l}) {
    } elsif ($OPT{c}) {
        print PIPE ".mode column\n";
    } else {
        print PIPE ".mode tabs\n";
    }
    if ($OPT{H}) {
    } else {
        print PIPE ".headers ON\n";
    }
    print PIPE $QUERY;
    close(PIPE);
} else {
    query_db($QUERY, $DB);
}

################################################################################
### Functions ##################################################################
################################################################################
sub query_db {
    my ($query, $db) = @_;

    my $dbh = DBI->connect("dbi:SQLite:dbname=$db");
    my $sth = $dbh->prepare($query);
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
}
