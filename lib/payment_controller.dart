// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
//
// class PaymentController {
//   static Map<String, dynamic>? paymentIntentData;
//
//   static Future<void> makePayment(
//       {required String amount, required String currency}) async {
//     try {
//       print("inside make payment");
//       paymentIntentData = await createPaymentIntent(amount, currency);
//       if (paymentIntentData != null) {
//         await Stripe.instance.initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//               applePay: true,
//               googlePay: true,
//               testEnv: true,
//               merchantCountryCode: 'US',
//               merchantDisplayName: 'Prospects',
//               customerId: paymentIntentData!['customer'],
//               paymentIntentClientSecret: paymentIntentData!['client_secret'],
//               customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
//             ));
//         await displayPaymentSheet();
//       }
//     } catch (e, s) {
//       print('exception:$e$s');
//     }
//   }
//
//   static displayPaymentSheet() async {
//     print("inside display payment");
//
//     try {
//       print("trying");
//       await Stripe.instance.presentPaymentSheet();
//       print("SUCCESS");
//
//       // Get.snackbar('Payment', 'Payment Successful',
//       //     snackPosition: SnackPosition.BOTTOM,
//       //     backgroundColor: Colors.green,
//       //     colorText: Colors.white,
//       //     margin: const EdgeInsets.all(10),
//       //     duration: const Duration(seconds: 2));
//     } on Exception catch (e) {
//       if (e is StripeException) {
//         print("Error from Stripe: ${e.error.localizedMessage}");
//       } else {
//         print("Unforeseen error: ${e}");
//       }
//     } catch (e) {
//       print("exception:$e");
//     }
//   }
//
//   //  Future<Map<String, dynamic>>
//   static createPaymentIntent(String amount, String currency) async {
//     print("inside create payment");
//
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       var response = await http.post(
//           Uri.parse('https://api.stripe.com/v1/payment_intents'),
//           body: body,
//           headers: {
//             'Authorization': 'sk_test_51LGT2LSDqMDQQeTEnj4QRyJkc8wnSkgpSz45d818RYrq7IT8xt6lYm5EUaJCKEKGQHlC4vP7VZNvRN58CGmOB9Gf00u2ihydn1',
//             'Content-Type': 'application/x-www-form-urlencoded'
//           });
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }
//
//   static calculateAmount(String amount) {
//     print("inside calculate amount");
//
//     final a = (int.parse(amount)) * 100;
//     return a.toString();
//   }
// }