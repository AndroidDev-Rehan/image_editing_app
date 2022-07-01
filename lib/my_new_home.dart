import 'dart:typed_data';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:image_editing_app/premium_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Payment.dart';
import 'main.dart';

class MyNewHomeScreen extends StatefulWidget {
  const MyNewHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyNewHomeScreen> createState() => _MyNewHomeScreenState();
}

class _MyNewHomeScreenState extends State<MyNewHomeScreen> {

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  XFile? image;
  File? updatedImage;
  bool loading = false;

  int turns = 0;

  late final AdWidget adWidget;

  @override
  void initState() {
    // limit = 15;
    // premium = false;
    super.initState();
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
    // Load ads.
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Clean Pic"),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset("assets/images/logo.png"),
            const SizedBox(
              height: 30,
            ),
            PremiumButton(onPressed: _purchase,),


          ],
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                           premium ? "You are enjoying premium account with unlimited image processing limit 💎" : "Your remaining daily image processing limit: $limit",
                            style:  TextStyle(
                              color: premium ? Colors.orange : null,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: !(updatedImage == null && image == null)
                                ? () {
                                    turns++;
                                    setState(() {});
                                  }
                                : null,
                            child: Row(
                              children: const [
                                Text(
                                  "Rotate  ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.rotate_right,
                                  color: Colors.white,
                                )
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (image == null && updatedImage == null)
                        ? Image.asset("assets/images/noImage.png")
                        : Stack(
                            children: [
                              RotatedBox(
                                quarterTurns: turns,
                                child: Image.file(File((updatedImage != null)
                                    ? updatedImage!.path
                                    : image!.path)),
                              ),
                              Positioned(
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      image = null;
                                      updatedImage = null;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 8),
                                    child: Icon(
                                      Icons.close,
                                      size: 40,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: image == null ? null : _improveImage,
                      style: ElevatedButton.styleFrom(
                          // primary: (image == null) ? Colors.grey[300] : null
                          ),
                      child: const Text(
                        "Convert to 300 DPI",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: (limit <= 0 && (!premium)) ? Colors.grey.shade300 : Colors.orange,
        onPressed: (limit <= 0 && (!premium)) ? null : _pickImage,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: premium ? null : Container(
        alignment: Alignment.center,
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
        child: adWidget,
      ),
    );
  }

  _pickImage() async {
    if (await Permission.storage.request().isGranted) {
      final ImagePicker picker = ImagePicker();
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print("setting state");
        setState(() {
          turns = 0;
          updatedImage = null;
        });
      } else {
        print("not setting state");
      }
    }
  }

  _improveImage() async {
    if (image != null) {
      setState(() {
        loading = true;
      });
      Uint8List resultBytes = await image!.readAsBytes();
      // print(resultBytes.toString());

      var dpi = 300;
      resultBytes[13] = 1;
      resultBytes[14] = (dpi >> 8);
      resultBytes[15] = (dpi & 0xff);
      resultBytes[16] = (dpi >> 8);
      resultBytes[17] = (dpi & 0xff);

      // print(resultBytes.toString());

      String tempPath = (await getTemporaryDirectory()).path;
      print(tempPath);
      String imgName =
          "IMG" + DateTime.now().microsecondsSinceEpoch.toString() + ".jpg";
      updatedImage = File('$tempPath/$imgName');
      await updatedImage!.writeAsBytes(resultBytes);

      /**You will not be able to see the image in android local storage, so rewriting the file, using the code below will show you image in Pictures Directory of android storage. Note: ImageGallerySaver is plugin, just copy and paste the dependency and have a go.*/

      final result1 =  await ImageGallerySaver.saveFile(updatedImage!.path, name: imgName);
      print(result1);
      showAlertDialog(context);

      // await _autoCorrectRotation();

          if (limit > 0 && (!premium)){
            limit--;
            String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
            print(formattedDate);
            await prefs.setInt('limit_$formattedDate', limit);
          }
      setState(() {
        image = null;
        loading = false;
      });
    }
  }

  _purchase() async {
    try{
      await Payment().makePayment("9.99");
      await prefs.setBool("premium", true);
      premium = true;

      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return MyNewHomeScreen();
      }));

    }
    on StripeException catch(e){
      if(e.error.code == FailureCode.Canceled){
        print("payment cancelled");
      }
    }
    // final bool available = await InAppPurchase.instance.isAvailable();
    // if (!available) {
    //   print("Not Available");
    //   // The store cannot be reached or accessed. Update the UI accordingly.
    // } else {
    //   print("AVAILABLE");
    // }

    // print("starting");
    // await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters());
    // await Stripe.instance.presentPaymentSheet();
    // log("done");


    // final PaymentMethod paymentMethod = await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(paymentMethodData: PaymentMethodData()));


  }

  // _autoCorrectRotation() async {
  //   // final Uint8List? fixedImageBytes = await FlutterImageCompress.compressWithFile(
  //   //   updatedImage!.path,
  //   //   rotate: 0,
  //   //   quality: 100,
  //   //   keepExif: false,
  //   //   autoCorrectionAngle: true,
  //   //   format: CompressFormat.jpeg,
  //   // );
  //   // if (updatedImage!=null){
  //   //   await updatedImage!.writeAsBytes(fixedImageBytes!);
  //   // }
  //
  //   final img.Image? capturedImage =
  //       img.decodeImage(await File(updatedImage!.path).readAsBytes());
  //   final img.Image orientedImage = img.bakeOrientation(capturedImage!);
  //   await File(updatedImage!.path).writeAsBytes(img.encodeJpg(orientedImage));
  // }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Success"),
      content: const Text("Image is converted to 300 dpi and saved in gallery"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose(){
    myBanner.dispose();
    super.dispose();
  }

}

