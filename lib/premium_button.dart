import 'package:flutter/material.dart';

import 'main.dart';

class PremiumButton extends StatefulWidget {
  const PremiumButton({Key? key, required this.onPressed}) : super(key: key);

  final Function onPressed;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? SizedBox(height: 70,
        child: Center(child: CircularProgressIndicator() ,)
    ) :  ElevatedButton(
        onPressed: premium ? null : () async{
          setState((){
            loading = true;
          });
          await widget.onPressed();
          setState((){
            loading = false;
          });
          },
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 5,),
            Text(
              "👑 Go Premium",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 5,),
            Text("- No daily images limit", style: TextStyle(fontSize: 12, color: Colors.white)),
            Text("- No ads", style: TextStyle(fontSize: 12, color: Colors.white)),
            SizedBox(height: 5,)

          ],
        ));

  }
}
