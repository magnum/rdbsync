<?php

function mysql_run($command)
{
  $params = array(
    ':host' => $_GET['host'],
    ':username' => $_GET['username'],
    ':password' => $_GET['password'],
    ':name' => $_GET['name'],
    ':dump_filename' => 'rdbsync.sql',
  );
  //$backup_file = 'rsbsync' . date("Y-m-d-H-i-s");
  $command = strtr($command, $params);
  $result = array(
    'exit_status' => null,
    'output' => null,
    'command' => $command,
  );
  try {
    exec($command, $output, $exit_status);
    $result['exit_status'] = $exit_status;
    $result['output'] = $output;
  } catch (Exception $e) {
    $result['output'] = $e->getMessage();
  }
  print(json_encode($result));
}


function remote_export(){
  mysql_run("(mysqldump -h :host -u :username -p':password' :name > :dump_filename) 2>&1");
}


function remote_import(){
  mysql_run("mysql -h :host -u :username -p':password' :name < :dump_filename");
}


switch ($_GET['action']) {
  case "remote_import":
    remote_import();
    break;
  case "remote_export":
    remote_export();
    break;
}
