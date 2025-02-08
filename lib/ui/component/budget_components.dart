import 'package:tgm/domain/budget/budget.dart';
import 'package:tgm/domain/budget/budget_repository.dart';
import 'package:tgm/ui/html.dart';

class BudgetComponents {
  static HTML managementView() {
    final Budget current = BudgetRepository.get();
    return HTML("""
<h1> Budget </h1>
<form hx-post="/api/set-budget" hx-swap="none">
  <div style="padding-bottom: 8px;">
    <label for="budget-input"> Budget </label>
    <input
      type="text"
      name="value"
      oninput="\$(this).val(\$(this).val().replace(/[^0-9.]/g, ''));"
      value="${current.value}"
      />
  </div>
  <input type="submit" value="Submit"/>
</form>
""");
  }
}
