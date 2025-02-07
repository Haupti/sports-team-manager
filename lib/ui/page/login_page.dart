import 'package:tgm/ui/html.dart';
import 'package:tgm/ui/page/base_page.dart';

HTML loginPage() {
  return pageRoot(HTML("""
<h1> &#127952; Login </h1>
<form style="display: grid; gap: 8px;" hx-post="/api/login" hx-swap="none">
    <label for="username-input"><strong>Name:</strong></label>
    <input id="username-input" type="text" name="username"/>
    <label for="password-input"><strong>Password:</strong></label>
    <input id="password-input" type="password" name="password"/>
    <input type="submit" value="Submit"/>
</form>
"""), style());
}
