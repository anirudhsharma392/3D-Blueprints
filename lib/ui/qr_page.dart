import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:circular_splash_transition/circular_splash_transition.dart';
import 'ar_main_page.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:spring_button/spring_button.dart';
import 'auto_detect_plane.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class QR extends StatefulWidget {
  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QR> {
  String code = "";
  double progress=0;
  bool flag=false;
  @override
  void initState() {
    super.initState();

      setState(() {
        progress=0;
       progress=97;

    });


  }

  Future scanBarCode() async {
    String barCodeResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
      if(barCodeResult!='-1'){
        setState(() {
          flag=true;
        });

        Future.delayed(Duration(milliseconds: 1000), () {

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AutoDetectPlane(url: barCodeResult)),
          );

        });
      }

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(backgroundColor: Colors.deepPurple,
      body: Center(
        child: Stack(
alignment: Alignment.center,
          children: <Widget>[
        flag?progressIndicator():Container(),
          Button(scanBarCode),
            flag? Container(
            margin: EdgeInsets.only(top: 150),
              alignment: Alignment.topCenter,
              child: Loading()):Container(),

        ],),
      ),
    ));
  }


  Widget Loading(){
    return Column(
      children: <Widget>[
    GlowingProgressIndicator(
    child: Text("Generating \n3D models",style: TextStyle(fontSize:30,color: Colors.white,fontWeight: FontWeight.bold),),
    ),

      ],
    );
  }
  Widget progressIndicator(){
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
          size: 300,
          startAngle: 0,angleRange: 360,
customColors: CustomSliderColors(
  progressBarColors: [Colors.blue,Colors.redAccent,Colors.purpleAccent],
  shadowMaxOpacity: 0.6,

),
          customWidths: CustomSliderWidths(progressBarWidth: 20,trackWidth: 5,handlerSize: 10)),
  innerWidget:(value){
        return Container();
  },
      initialValue: progress,
    );

  }
  Widget Button(Function onPress) {
    return SpringButton(
      SpringButtonType.OnlyScale,
      Container(
        height: 70,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: Colors.black.withOpacity(.5),
              offset: Offset(6.0, 7.0),
            ),
          ],
//shape: BoxShape.rectangle,
//border: Border.all(),
          color: Colors.redAccent,
        ),
        child: Center(
          child: Text("Scan QR",
              style: TextStyle(
                color: Colors.white.withOpacity(0.87),
                fontWeight: FontWeight.w700,
                fontSize: 25.0,
              )),
        ),
      ),
      onTapDown: (_) {
        onPress();
      },
    );
  }
}
