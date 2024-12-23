<?php

/**
 * Validate an email address.
 *
 * @param string $email
 * @return bool
 */
function validate_email($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}


/**
 * Validate a password.
 *
 * Checks if a given password is valid, i.e.:
 * - at least 8 characters long
 * - contains at least one uppercase letter
 * - contains at least one lowercase letter
 * - contains at least one number
 *
 * @param string $password
 * @return bool
 */
function validate_password($password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    return strlen($password) >= 8 &&
           preg_match('/[A-Z]/', $password) &&
           preg_match('/[a-z]/', $password) &&
           preg_match('/[0-9]/', $password);
}

/**
 * Validate a username.
 *
 * Checks if a given username is valid, i.e.:
 * - 3 to 20 characters long
 * - contains only letters, numbers, and underscores
 *
 * @param string $username
 * @return bool
 */

function validate_username($username) {
    // 3-20 characters, letters, numbers, underscores
    return preg_match('/^[a-zA-Z0-9_]{3,20}$/', $username);
}