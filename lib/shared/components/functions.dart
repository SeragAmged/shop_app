import 'package:flutter/material.dart';
import '../../modules/login/login_screen.dart';
import '../network/local/cache_helper.dart';

void navigateTo(BuildContext context, pageTo) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => pageTo,
    ),
  );
}

void navigateToWithReplacement(BuildContext context, pageTo) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => pageTo,
    ),
    (Route<dynamic> route) => false,
  );
}

void logOut(context) {
  CacheHelper.removeData(key: 'token').then(
    (value) {
      if (value) navigateToWithReplacement(context, LoginScreen());
    },
  );
}
