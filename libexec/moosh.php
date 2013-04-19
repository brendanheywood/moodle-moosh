<?php

ini_set('display_errors', 'On');
error_reporting(E_ALL | E_STRICT);


/*
 * attempts to find, and then load a moodle config by walking up
 * up the dir tree
 */
function find_config (){
    $path = getcwd();

    while ($path != '/'){
        $cfg = "$path/config.php";
        if ( file_exists( $cfg ) ){
            return $path;
        } else {
            $path = dirname ( $path );
        }
    }
    return null;
}


function cli_run($cmd){
    $descriptorspec = array(
        1 => array('pipe', 'w'), // stdout
        2 => array('pipe', 'w'), // stderr
    );
    $process = proc_open($cmd, $descriptorspec, $pipes);
    if (!is_resource($process)){
        throw new RuntimeException('Unable to execute the command.');
    }
    stream_set_blocking($pipes[1], false);
    stream_set_blocking($pipes[2], false);
}

function execute($cmd, $env = null){

    print "Exec: $cmd \n";

    $child=proc_open($cmd,array(
        0=>array('pipe','r'), # stdin
        1=>array('pipe','w'), # stdout
        2=>array('pipe','w')  # stderr
    ),$pipes, null, $env = null);

    # read from parent stdin and pass into child
    $status = proc_get_status($child);
    print "Status = ".var_dump($status,1) . "\n";

    $alive = true;
    
    while (1){

        # if child has sent data sending back to the parents stdout
        if (!feof($pipes[1])) {
            echo fgets($pipes[1]);
            flush();
        }
    }

    print "No more stdout \n";

#    fwrite($pipes[0],$stdin);  //add to argument if you want to pass stdin                  
#    fclose($pipes[0]);
#    $stdout=stream_get_contents($pipes[1]);
#    fclose($pipes[1]);
#    $stderr=stream_get_contents($pipes[2]);
#    fclose($pipes[2]);

        # read from stdin and then pass that to the child proc
#        fwrite($pipes[0], $in);

    # it may have already closed?
    $return = proc_close($child);    

    print "Return = $return\n";
    return $return;
}

