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





