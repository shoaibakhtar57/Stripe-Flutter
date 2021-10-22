// ignore_for_file: prefer_const_constructors, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            await makePayment();
          },
          child: Container(
            height: 50.0,
            width: 200.0,
            color: Colors.green,
            child: Center(child: Text('Pay')),
          ),
        ),
      ],
    ));
  }

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
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ));

      setState(() {
        paymentIntentData = null;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Payment successfully done')));
    } on StripeException catch (e) {
      print('Exception::::::: $e');

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text('Transaction failed'),
              ));
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
}
