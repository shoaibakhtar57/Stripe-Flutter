import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  Stripe.publishableKey =
      "pk_test_51JnOylKB1mUKF8fdOp5xylpfglHJpvbVDqdQRqjWSzITmCiHB9NUdYweoxidCb8vtJ7EgF0ZuaHHjY8w9XVM2biD00mWkYpS78";
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
