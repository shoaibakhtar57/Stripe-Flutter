import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:stripe_app/app/modules/home/controllers/builderIds.dart';

class HomeController extends GetxController {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent('20', 'USD');

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'SHOAIB'));

      displayPaymentSheet();
    } catch (e) {
      print('Exception::::::: $e');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      paymentIntentData = null;
      update([kPayment]);
      Get.snackbar('Payment Done', 'Payment successfully done');
    } on StripeException catch (e) {
      print('Exception::::::: $e');
      Get.snackbar('Payment Failed', 'An error occured. Please try again');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51JnOylKB1mUKF8fdiNIyNJN0fx6esUxFQYMqz0020x0llx4rAvQiAd7pIDaPVDBurGflK7vzYYIrLDTLuhqKzcTC00MyJPSeDj',
            'Content-type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body.toString());
    } catch (e) {
      print('Exception::::::: $e');
    }
  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
