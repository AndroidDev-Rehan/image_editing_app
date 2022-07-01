import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_editing_app/main.dart';
import 'package:image_editing_app/my_new_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    Timer(
        const Duration(seconds: 4), () =>
            _navigator.pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const MyNewHomeScreen())));
    return Scaffold(
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/logoBG.png"),
          Text("CLEANPIC", style: TextStyle(fontSize: 40, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          const SizedBox(height: 50,)
        ],
      ),),
    );
  }
}
