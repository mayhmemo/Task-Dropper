import 'package:flutter/material.dart';

class SnackbarUtils {

  showCustomSnackbar(String message, Color backgroundColor, Color textColor) {
    return SnackBar(
      content: Center(
        child: Text(
          message,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }

}