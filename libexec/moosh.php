<?php



/*
 * attempts to find, and then load a moodle config by walking up
 * up the dir tree
 */
function load_config (){
    $path = getcwd();
    while ($path != '/'){
        if ( file_exists($path.'/config.php') ){
            return $path;
        } else {
            $path = dirname ( $path );
        }
    }
    return null;
}





