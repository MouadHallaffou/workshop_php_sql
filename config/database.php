<?php

/**
 * Connect to a MySQL database using the mysqli extension.
 *
 * This function establishes a connection to a MySQL database. If the
 * connection fails, it logs an error and terminates the program.
 *
 * @return A MySQLi connection object.
 */

 use Dotenv\Dotenv;
 require '../../vendor/autoload.php';
 $dotenv = Dotenv::createImmutable(dirname(__DIR__));
 $dotenv->load();

// function connect_db() {
//     $host = 'localhost';
//     $username = 'root';
//     $password = '';
//     $database = 'devblog_db';

    
    $mysqli = mysqli_connect($_ENV['DB_SERVER'], $_ENV['DB_USERNAME'], $_ENV['DB_PASSWORD'], $_ENV['DB_NAME']);
    
    if (mysqli_connect_errno()) {
        error_log("Connection failed: " . mysqli_connect_error());
        die("Connection failed. Please try again later.");
    }
    
    return $mysqli;
}