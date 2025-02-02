import 'package:tgm/ui/html.dart';

HTML basePage(HTML main) {
  return HTML("""
<!DOCTYPE html>
<html>
  <head>
    <script></script>
    <script src="https://code.jquery.com/jquery-3.7.1.slim.min.js" integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/htmx.org@2.0.4"></script>
  </head>
  <style>
    body {
      font-family: Arial, sans-serif;
      max-width: 80ch;
      margin: auto;
      padding: 16px;
    }
    nav > a {
      text-decoration: none;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }

    th {
      padding: 8px;
      text-align: left;
      border-bottom: 1px solid black;
    }

    td {
      padding: 8px;
    }

    tr:nth-child(even) {
      background-color: #f2f2f2; 
    }

    tr:nth-child(odd) {
      background-color: #ffffff;
    }

    tr:hover {
      background-color: #e0e0e0;
    }
  </style>
  <body>
    <nav style="display: flex; gap: 8px; align-items: center;">
      <a style="font-size: 36px;" href="/">&#127952;</a>
      <a href="/">Home</a>
      <a href="/member-manager">Members</a>
    </nav>
    <main>
      ${main.render()}
    </main>
  </body>
</html>
""");
}
