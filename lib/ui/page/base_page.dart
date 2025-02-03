import 'package:tgm/ui/html.dart';

HTML basePage(HTML main) {
  return HTML("""
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
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
    nav a {
      color: #017dc7;
      text-decoration: none;
    }
    .navLink {
      padding: 8px;
    }
    .navLink:hover {
      background-color: #cce5f3;
    }
    nav a:visited {
      color: #017dc7;
    }
    nav {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      align-items: center;
      margin-bottom: 16px;
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
    <nav>
      <a style="font-size: 36px;" href="/">&#127952; TGM H4</a>
      <a class="navLink" href="/">Home</a>
      <a class="navLink" class="navLink" href="/transactions">Fines</a>
      <div>
        <a class="navLink" href="/member-manager">Manage-Members</a>
        <a class="navLink" href="/transactions-manager">Manage-Fines</a>
        <a class="navLink" href="/workout-manager">Manage-Workouts</a>
      </div>
    </nav>
    <main>
      ${main.render()}
    </main>
  </body>
</html>
""");
}
