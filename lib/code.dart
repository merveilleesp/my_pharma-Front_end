import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

sendMailInvitation(
    String email, String confirmation_code) async {
  String username = "merveilleesp@gmail.com";
  String password = "axkubkxgcqjdcjfq";

  final smtpServer = gmail(username, password);

  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(email)
  //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
  // ..bccRecipients.add(Address('cedricabionan65@gmail.com'))
    ..subject = 'code de confirmation'
  // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html =
        "<h1 style=\"color: #44a8fa;font-size: xxx-large; text-align:center\">Code de confirmation</h1> "
        "<p style=\"line-height: 2;text-align:center\">Vous avez été selectionné pour participer à une election. <br>  "
        "  Voyez ci-dessous les informations qui vous permettront de voter: <br>   "
        " <span>Code du Vote: </span> "
        "<span style=\"font-weight: bold;\">$confirmation_code</span><br>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message envoyé: ' + sendReport.toString());
  } on MailerException catch (e) {
    print(e.toString());
    for (var p in e.problems) {
      Fluttertoast.showToast(msg: "Un problème s'est posé, ${p.msg}");
      print('Problem: ${p.code}: ${p.msg}');
    }
  } on SocketException catch (e) {
    print(e.toString());
    Fluttertoast.showToast(
        msg: "Un problème s'est posé, l'envoi de mail a échoué");
    print('Problem: Manque de connexion ');
  } catch (e) {
    print(e);
    print("n'importe quoi");
  }
}
