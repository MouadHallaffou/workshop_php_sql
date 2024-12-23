<?php

function get_base_url() {
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http';
    return $protocol . '://' . $_SERVER['HTTP_HOST'];
}

function get_current_url() {
    return get_base_url() . $_SERVER['REQUEST_URI'];
}