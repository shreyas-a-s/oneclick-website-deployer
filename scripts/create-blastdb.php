<?php

// Bootstrap Drupal
define('DRUPAL_ROOT', getcwd());
require_once DRUPAL_ROOT . '/includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);

// Get the admin user
$admin_user = user_load(1); // Assuming the admin user has uid 1

// Create a content of type "blastdb"
$blastdb = new stdClass();
$blastdb->type = 'blastdb'; // Custom content type
$blastdb->status = 1; // Published

// Set your custom fields
$blastdb->db_name = '16S_ribosomal_RNA';
$blastdb->db_path = DRUPAL_ROOT . '/tools/blast/db/16S_ribosomal_RNA/16S_ribosomal_RNA';
$blastdb->db_dbtype = 'nucleotide';

$blastdb->uid = $admin_user->uid; // Set the author to the admin user

node_save($blastdb);

?>

