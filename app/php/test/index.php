<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" type="image/x-icon" href="/php/favicon.ico">
</head>
<body>

<?php
echo "My first PHP script out of Docker!</br></br>";
echo "Greetings from container/hostname: ".getenv('HOSTNAME');
?>

<pre>
<?php
print_r($_SERVER);
?>
</pre>

</body>
</html>
