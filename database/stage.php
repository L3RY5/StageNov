<?PHP

$user_name = "sql7267243";
$password = "CHndH39PhS";
$database = "sql7267243";
$server = "sql7.freemysqlhosting.net";

$conect = mysqli_connect($server, $user_name, $password);
if ($conect) {
    print"connection established";
} else {
   die("error coonnecting tio the database");
   print"Not connected";
}

?>