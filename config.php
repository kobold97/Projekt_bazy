<?php
session_start();

$conn = oci_connect('hr', 'hr', 'localhost/Projekt');

$stid = oci_parse($conn, 'select employee_id from employees');
oci_execute($stid);

echo "<table>\n";
while (($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
    echo "<tr>\n";
    foreach ($row as $item) {
        echo "  <td>".($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;")."</td>\n";
    }
    echo "</tr>\n";
}
echo "</table>\n";

//require "User.php";
//require "Event.php";
//$user = new User($connect);
//$event = new Event($connect);
?>