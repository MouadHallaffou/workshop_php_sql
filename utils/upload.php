<?php
/**
 * Handles a file upload operation, performing the following steps:
 * 
 * 1. Checks the upload error status and returns an error if the upload failed.
 * 2. Checks the file size and returns an error if the file is larger than the
 *    specified maximum size.
 * 3. Checks the file mime type against the allowed types. If the mime type
 *    is not in the allowed types, an error is returned.
 * 4. Generates a new, unique filename for the uploaded file, based on the
 *    original file extension.
 * 5. Moves the uploaded file to the specified directory.
 * 6. Returns an array with a "success" key set to true/false and an "error"
 *    key set to an error message, or a "filename" key set to the new filename
 *    and a "path" key set to the full path of the uploaded file.
 * 
 * @param array $file the file array from a $_FILES superglobal
 * @param array $allowed_types an array of allowed mime types
 * @param string $upload_dir the directory to which the file should be uploaded
 * @param int $max_size the maximum file size, in bytes
 * @return array the result of the upload operation
 */
function handle_file_upload($file, $allowed_types, $upload_dir, $max_size = 5242880) {
    if ($file['error'] !== 0) {
        return ['success' => false, 'error' => 'Upload failed'];
    }
    
    if ($file['size'] > $max_size) {
        return ['success' => false, 'error' => 'File too large'];
    }
    
    $file_info = finfo_open(FILEINFO_MIME_TYPE);
    $mime_type = finfo_file($file_info, $file['tmp_name']);
    finfo_close($file_info);
    
    if (!in_array($mime_type, $allowed_types)) {
        return ['success' => false, 'error' => 'Invalid file type'];
    }
    
    $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    $new_filename = uniqid() . '.' . $ext;
    $destination = $upload_dir . $new_filename;
    
    if (!move_uploaded_file($file['tmp_name'], $destination)) {
        return ['success' => false, 'error' => 'Move failed'];
    }
    
    return [
        'success' => true,
        'filename' => $new_filename,
        'path' => $destination
    ];
}