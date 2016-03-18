<?php
$body = '';
$fh   = @fopen('php://input', 'r');
if ($fh)
{
  while (!feof($fh))
  {
    $s = fread($fh, 1024);
    if (is_string($s))
    {
      $body .= $s;
    }
  }
  fclose($fh);
}
print("-------------- PHP Input Stream ----------------\n$body\n\n");

$body2 = http_get_request_body();
print("---------- http_get_request_body() -------------\n$body2\n\n");

?>