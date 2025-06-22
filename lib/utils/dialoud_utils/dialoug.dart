import 'package:flutter/material.dart';

class DialougUtiles {
  static void showLoadingDilaogs(BuildContext context, String text,
      {bool isDismissible = true}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 8,
              ),
              Text(text),
            ],
          ),
        ),
        barrierDismissible: isDismissible);
  }

  static void hideDialougs(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context, String message,
      {String? posActionTitles,
        String? negActionTitles,
        VoidCallback? posAction,
        VoidCallback? negAction,
        bool isDismissable = false}) {
    List<Widget> actions = [];
    if (posActionTitles != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(posActionTitles)));
    }
    if (negActionTitles != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(negActionTitles)));
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            message,
          ),
          actions: actions,
        ),
        barrierDismissible: isDismissable);
    }
}
