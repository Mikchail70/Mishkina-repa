<html lang="en">

<head>
  <title>Sigachev garage</title>
  <link rel="stylesheet" href="style.css" type="text/css" />
</head>

<body>
  <h1>Garage</h1>
  <table>
    <tr>
      <th>avto</th>
      <th>number</th>
      <th>speed</th>
    </tr>
    <?php
        $mysqli = new mysqli(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASSWORD'), getenv('DB_NAME'));
        $result = $mysqli->query("SELECT * FROM box"); foreach ($result as $row) {
      echo "
      <tr>
        <td>{$row['avto']}</td>
        <td>{$row['number']}</td>
        <td>{$row['speed']}</td>
      </tr>
      "; } ?>
  </table>
  <?php
      phpinfo();
    ?>
</body>

</html>
   
