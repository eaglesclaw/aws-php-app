<?php
$servername = "localhost";
$username = "username";
$password = "password";

// Connection
$conn = new mysqli($servername,
		$username, $password);

// For checking if connection is
// successful or not
if ($conn->connect_error) {
die("Connection failed: "
	. $conn->connect_error);
}
echo "Connected successfully";
?>
