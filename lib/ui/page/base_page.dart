import 'package:tgm/domain/login/authentication.dart';
import 'package:tgm/ui/html.dart';

HTML pageRoot(HTML body, HTML style) {
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
      ${style.render()}
  </style>
  <body>
      ${body.render()}
  </body>
</html>
""");
}

HTML basePage(HTML main, Authentication auth) {
  return pageRoot(body(main, auth), style());
}

HTML body(HTML main, Authentication auth) {
  return HTML("""
<nav>
  <a style="font-size: 36px;" href="/">&#127952; TGM H4</a>
  <a class="navLink" href="/">Home</a>
  <a class="navLink" class="navLink" href="/transactions">Fines</a>
  <a class="navLink" class="navLink" href="/workouts">Workouts</a>
  <div style="display: flex; flex-wrap: wrap; gap: 8px;">
    ${auth.isAdmin ? """<a class="navLink" href="/member-manager">Manage-Members</a>""" : ""}
    ${auth.isAtLeastMod ? """<a class="navLink" href="/transactions-manager">Manage-Fines</a> """ : ""}
    ${auth.isAtLeastMod ? """<a class="navLink" href="/workout-manager">Manage-Workouts</a>""" : ""}
  </div>
</nav>
<main>
  ${main.render()}
</main>
""");
}

HTML style() {
  return HTML("""
  body {
    font-family: Arial, sans-serif;
    max-width: 80ch;
    margin: auto;
    padding: 16px;
  }
  nav a {
    color: #017dc7;
    text-decoration: none;
    text-wrap: nowrap;
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

  button, input[type="submit"] {
    background-color: #dddddd;
    box-shadow: 4px 4px 2px #eeeeee;
    border: 0;
    border-radius: 2px;
    padding: 8px;
  }

  button:hover, input[type="submit"]:hover {
    box-shadow: 2px 2px 0px #eeeeee;
  }
  
  input {
    border: 1px solid #e0e0e0;
    border-radius: 2px; 
    padding: 8px;
  }

  select {
    border: 1px solid #e0e0e0;
    border-radius: 2px; 
    padding: 8px;
  }

  input[type="checkbox"] {
    border: 1px solid #017dc7;
    border-radius: 2px; 
    padding: 8px;
  }

  .fadeout {
    animation: fadeOut 3s forwards;
  }
  @keyframes fadeOut {
    from {
      opacity: 1;
    }
    99% {
      opacity: 1;
    }
    to {
      opacity: 0; 
      display: none;
    }
  }
""");
}
