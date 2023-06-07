import 'package:flutter/material.dart';

class CommonUtils {
  static void showSnackBar(BuildContext context, String msg) {
    final snack = SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
