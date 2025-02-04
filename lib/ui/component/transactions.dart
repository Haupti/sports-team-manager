import 'package:tgm/domain/date_utils.dart';
import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/transaction/transaction_info.dart';
import 'package:tgm/domain/transaction/transaction_info_service.dart';
import 'package:tgm/ui/html.dart';

class TransactionComponents {
  static HTML history() {
    final transactions = TransactionInfoService.getAllNewestFirst();
    return HTML("""
<h1> Transaction History </h1>
<table>
  <tr id="transaction-history-headline">
    <td> Affected Member</td>
    <td>Type</td>
    <td>Reason</td>
    <td>Timestamp</td>
  </tr>
  ${transactions.map((it) => transactionToRow(it).render()).join("\n")}
</table>
""");
  }

  static HTML managableHistory() {
    final transactions = TransactionInfoService.getAllNewestFirst();
    return HTML("""
<h1> Transaction History </h1>
<table>
  <tr id="transaction-history-headline">
    <td>Delete</td>
    <td>Affected Member</td>
    <td>Type</td>
    <td>Reason</td>
    <td>Timestamp</td>
  </tr>
  ${transactions.map((it) => transactionToManagableRow(it).render()).join("\n")}
</table>
""");
  }

  static HTML transactionToManagableRow(TransactionInfo info) {
    return HTML("""
<tr id="managable-transaction-row-${info.transaction.id}">
  <td><button
    hx-post="/api/delete-transaction"
    hx-swap="outerHTML"
    hx-target="#managable-transaction-row-${info.transaction.id}"
    hx-vals='{"id":"${info.transaction.id}"}'
  >
    &#128465;
  </button></td>
  <td>${info.memberName}</td>
  <td>${info.type.name}</td>
  <td>${info.reason}</td>
  <td>${info.timestamp.prettyDate()}</td>
</tr>
      """);
  }

  static HTML transactionToRow(TransactionInfo info) {
    return HTML("""
<tr>
  <td>${info.memberName}</td>
  <td>${info.type.name}</td>
  <td>${info.reason}</td>
  <td>${info.timestamp.prettyDate()}</td>
</tr>
      """);
  }

  static HTML manageTransactions() {
    final List<Member> members = MemberRepository.getAll();
    return HTML("""
<h1> New Transaction </h1>
<form hx-post="/api/add-transaction" hx-swap="afterend" hx-target="#transaction-history-headline">
  <div style="margin-bottom: 8px;">
    <label for="affected-member">Affected Member</label>
    <select id="affected-member" name="member-id" style="width: 100%;">
      <option value="--">--</option>
      ${members.map((it) => """<option value="${it.id}">${it.name}</option>""").join("\n")}
    </select>
  </div>
  <div>
    <label for="amount-input">Amount</label>
    <input id="amount-input" name="amount" type="number" value="2"/>
  </div>
  <div>
    <h2> Type </h2>
    <div>
      <input 
        id="fine-type-input"
        name="type"
        value="fine"
        type="radio"
        checked="true"
        onchange="\$('#fine-type-input').is(':checked') ? \$('#fine-reason-section').css('display','block') : null;"
      />
      <label for="fine-type-input">Fine</label>
    </div>
    <div>
      <input
          id="settlement-type-input"
          name="type"
          type="radio"
          value="settlement"
          onchange="\$('#settlement-type-input').is(':checked') ? \$('#fine-reason-section').css('display','none') : null;"
      />
      <label for="settlement-type-input">Settlement</label>
    </div>
  </div>
  <div id="fine-reason-section">
    <h2> Reason </h2>
    <div>
      <input id="reason-too-late" name="reason" type="radio" value="too-late" checked="true"/>
      <label for="reason-too-late">Too late</label>
    </div>
    <div>
      <input id="reason-wrong-registration" name="reason" type="radio" value="wrong-registration"/>
      <label for="reason-wrong-registration">Incorrect registration</label>
    </div>
    <div>
      <input id="reason-no-registration" name="reason" type="radio" value="no-registration"/>
      <label for="reason-no-registration">No registration</label>
    </div>
    <div>
      <input id="reason-too-late-matchday" name="reason" type="radio" value="too-late-match-day"/>
      <label for="reason-too-late-matchday">Match day: Too late</label>
    </div>
    <div>
      <input id="reason-wrong-registration-matchday" name="reason" type="radio" value="wrong-registration-match-day"/>
      <label for="reason-wrong-registration-matchday">Match day: Incorrect registration</label>
    </div>
    <div>
      <input id="reason-no-registration-matchday" name="reason" type="radio" value="no-registration-match-day"/>
      <label for="reason-no-registration-matchday">Match day: No registration</label>
    </div>
  </div>
  <input style="margin-top: 8px;" type="submit" value="Submit"/>
</form>
${managableHistory().render()}
""");
  }
}
