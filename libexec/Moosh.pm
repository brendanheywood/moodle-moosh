package Moosh;
use strict;
use warnings;
use Exporter;

our @ISA= qw( Exporter );

our @EXPORT = qw( find_moodle parse_config info remote_backup remote_cmd);


sub info {
    use Term::ANSIColor;
    my ($good, $message) = @_;

    print ''.($good >   0 ? (color("green")   .'[OK]    '.color("reset")) :
              $good == -1 ? (color("blue")    .'[DEBUG] '.color("reset")) :
                            (color("red")     .'[FAIL]  '.color("reset"))
             );
    print $message;

}

# $dir = start dir, works it way up the tree to find a config.php file
# $force = if true die's if not found
# returns a path 
sub find_moodle {
    use File::Basename;
    my ($dir, $name, $force) = @_;
    while ($dir ne '/'){
        my $cfg = "$dir/config.php";
        if (-e $cfg){
            info (1, "Found '$name' config = $cfg\n");
            return $cfg;
        }
        $dir = dirname($dir); 
    }
    if ($force){
        info (0, "Can't find '$name' moodle install\n");
        exit;
    }

    return;
}

# given the contents of a file
# parse out and return the $CFG vars
#
sub parse_config {

    my ($config) = @_;
    my $c = 0;
    my %db = ();
    my $key;
    my $val;
    my @lines = split /\n/, $config;

    foreach my $line (@lines){
        if($line =~ /(^\$CFG->(.*?)\s.*= '(.*?)')/){
            $key = $2;
            $val = $3;
            $db{$key} = $val;
            $c++;
#            print "Line: Key '$key' Val '$val'--- \n";
        }
    }
    info ($c, "Parsed $c config items\n");
    return %db;
}

sub remote_cmd {

    my ($host, $cmd, $stderr) = @_;

    my $remote_cmd = "ssh $host $cmd";
    if ($stderr){
        $remote_cmd .= " 2>&1";
    }
    my $result = `$remote_cmd`;
    return $result;
}


sub remote_backup {
    my ($remote_host, %cfg) = @_;

    my ($file, $cmd) = get_backup_cmd(%cfg);

    my $res = remote_cmd($remote_host, $cmd, 1);
    if (length($res)){
        info (0, "Remote backup on $remote_host to $file\n");
        info (-1, "$cmd \n");
        info (-1, "$res \n");
        exit;
    }
    info (1, "Remote backup to $remote_host:$file\n");
    return $file;
}

sub get_backup_cmd {
    my (%db) = @_;

	use Data::Dumper;
	use Sys::Hostname;
	use POSIX qw/strftime/;
	my $host = hostname;
	my $date = strftime('%d-%b-%Y-%H:%M',localtime);

	#print Dumper (%db);

    my $command;

	my $backup_file = "/tmp/$host\_$db{dbtype}_$db{dbhost}_$db{dbname}_$date.sql";
	if($db{dbtype} eq 'mysql' or $db{dbtype} eq 'mysqli'){
		$command = "mysqldump --skip-lock-tables -u $db{dbuser} --password='$db{dbpass}' $db{dbname} -r $backup_file -h $db{dbhost}";
	} elsif($db{dbtype} eq 'postgres7' || $db{dbtype} eq 'pgsql'){
	# This isn't terribly secure but we're generally dealing with dev boxes so no-one else should be around
	 	$command = "export PGPASSWORD=\"$db{dbpass}\"; pg_dump -Fc -O $db{dbname} -U $db{dbuser} -f $backup_file -h $db{dbhost}";
	} else {
		info (0, "Don't know how to backup type: $db{dbtype}\n");
		exit;
	}

    return ($backup_file, $command);

}




1;
