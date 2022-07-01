import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:image_editing_app/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

late int limit;
late bool premium;
late final SharedPreferences prefs;

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  Stripe.publishableKey = "pk_test_51I9cjpBmB1AZ3VVDYcEdZqJnrumRZUU6si0TqOyfdOSrncEX7RadLvqqFBZCDHB82d8rnG23OjijzjOT1pUF6IEE00h4ajWKGc";
  prefs = await SharedPreferences.getInstance();

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  limit = prefs.getInt('limit_$formattedDate') ?? 5;
  premium = prefs.getBool('premium') ?? false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(),
    );
  }
}
