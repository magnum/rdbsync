<?php

function get()
{
  // DB connection info
  $host = $_GET['host'];
  $username = $_GET['username'];
  $password = $_GET['password'];
  $db = $_GET['db'];
  //$backup_file = 'rsbsync' . date("Y-m-d-H-i-s");
  $backup_file = 'rdbsync.sql';
  $result = array(
    'exit_status' => null,
    'output' => null,
  );
  try {
    $command = "(mysqldump -h $host -u $username -p$password $db > $backup_file) 2>&1";
    exec($command, $output, $exit_status);
    $result['exit_status'] = $exit_status;
    $result['output'] = $output;
    
  } catch (Exception $e) {
    $result['output'] = $e->getMessage();
  }
  print(json_encode($result));
}

switch ($_GET['action']) {
  case "get":
    get();
    break;
}
