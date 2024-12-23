<?php

function create_slug($string) {
    // Replace non letter or digits by -
    $string = preg_replace('~[^\pL\d]+~u', '-', $string);

    // Transliterate
    if (function_exists('iconv')) {
        $string = iconv('utf-8', 'us-ascii//TRANSLIT', $string);
    }

    // Remove unwanted characters
    $string = preg_replace('~[^-\w]+~', '', $string);

    // Trim
    $string = trim($string, '-');

    // Remove duplicate -
    $string = preg_replace('~-+~', '-', $string);

    // Lowercase
    $string = strtolower($string);

    // If string is empty, return 'n-a'
    if (empty($string)) {
        return 'n-a';
    }

    return $string;
}

function sanitize_string($string) {
    return htmlspecialchars(strip_tags(trim($string)));
}

function validate_image($file) {
    // Check if file was uploaded without errors
    if ($file['error'] !== UPLOAD_ERR_OK) {
        return "Error uploading file. Code: " . $file['error'];
    }

    // Check file size (max 2MB)
    if ($file['size'] > 2 * 1024 * 1024) {
        return "File is too large. Maximum size is 2MB.";
    }

    // Check file type
    $allowed_types = ['image/jpeg', 'image/png', 'image/gif'];
    if (!in_array($file['type'], $allowed_types)) {
        return "Invalid file type. Allowed types: JPG, PNG, GIF";
    }

    return true;
}

function generate_random_string($length = 10) {
    return substr(str_shuffle(str_repeat($x='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', 
        ceil($length/strlen($x)))), 1, $length);
}

function generate_csrf_token() {
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function verify_csrf_token() {
    if (!isset($_SESSION['csrf_token']) || !isset($_POST['csrf_token']) ||
        $_SESSION['csrf_token'] !== $_POST['csrf_token']) {
        http_response_code(403);
        die('Invalid CSRF token');
    }
}

function redirect($path) {
    header("Location: $path");
    exit();
}

function display_error($message) {
    return "<div class='alert alert-danger'>$message</div>";
}

function display_success($message) {
    return "<div class='alert alert-success'>$message</div>";
}

function time_elapsed_string($datetime, $full = false) {
    $now = new DateTime;
    $ago = new DateTime($datetime);
    $diff = $now->diff($ago);

    $string = array(
        'y' => 'year',
        'm' => 'month',
        'd' => 'day',
        'h' => 'hour',
        'i' => 'minute',
        's' => 'second',
    );

    // Calculate weeks from days
    $weeks = floor($diff->days / 7);
    $days = $diff->days % 7;

    foreach ($string as $k => &$v) {
        if ($k === 'd') {
            // Handle days specially because of weeks calculation
            if ($weeks > 0) {
                $string['w'] = $weeks . ' week' . ($weeks > 1 ? 's' : '');
                if ($days > 0) {
                    $v = $days . ' ' . $v . ($days > 1 ? 's' : '');
                } else {
                    unset($string['d']);
                }
            } else if ($diff->$k) {
                $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? 's' : '');
            } else {
                unset($string[$k]);
            }
        } else if ($diff->$k) {
            $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? 's' : '');
        } else {
            unset($string[$k]);
        }
    }

    if (!$full) {
        $string = array_slice($string, 0, 1);
    }

    return $string ? implode(', ', $string) . ' ago' : 'just now';
}
