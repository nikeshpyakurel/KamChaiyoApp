import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String content,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: color ?? Colors.black,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
