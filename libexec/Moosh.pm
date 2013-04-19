package Moosh;
use strict;
use warnings;
use Exporter;

our @ISA= qw( Exporter );

our @EXPORT = qw( find_moodle parse_config );


sub info {
    use Term::ANSIColor;
    my ($good, $message) = @_;

    print ''.($good ? color("green").'[OK]   '.color("reset")
                    : color("red")  .'[FAIL] '.color("reset") );
    print $message;

}

# $dir = start dir, works it way up the tree to find a config.php file
# $force = if true die's if not found
# returns a path 
sub find_moodle {
    use File::Basename;
    my ($dir, $force) = @_;
    while ($dir ne '/'){
        my $cfg = "$dir/config.php";
        if (-e $cfg){
            info (1, "Found cfg = $cfg\n");
            return $cfg;
        }
        $dir = dirname($dir); 
    }
    if ($force){
        info (0, "Can't find a moodle install\n");
        exit;
    }

    return;
}

# given the contents of a file
# parse out and return the $CFG vars
#
sub parse_config {

    my ($config) = @_;

    my @lines = split /\n/, $config;

    my %db = ();

    my $key;
    my $val;

    foreach my $line (@lines){
        if($line =~ /(^\$CFG->db(.*?)\s.*= '(.*?)')/){
            $key = $2;
            $val = $3;
            $db{$key} = $val;
            print "Line: Key '$key' Val '$val'--- \n";
        }
    }
    return %db;
}


1;
