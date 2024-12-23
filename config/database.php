<?php

/**
 * Connect to a MySQL database using the mysqli extension.
 *
 * This function establishes a connection to a MySQL database. If the
 * connection fails, it logs an error and terminates the program.
 *
 * @return A MySQLi connection object.
 */
function connect_db() {
    $host = 'localhost';
    $username = 'root';
    $password = '';
    $database = 'devblog_db';
    
    $mysqli = mysqli_connect($host, $username, $password, $database);
    
    if (mysqli_connect_errno()) {
        error_log("Connection failed: " . mysqli_connect_error());
        die("Connection failed. Please try again later.");
    }
    
    return $mysqli;
}