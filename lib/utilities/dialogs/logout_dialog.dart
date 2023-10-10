import 'package:flutter/material.dart';
import 'package:voteit/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to Log Out?',
    optionBuilder: () => {
      'Cancel': false,
      'Logout': true,
    },
  ).then((value) => value ?? false);
}
