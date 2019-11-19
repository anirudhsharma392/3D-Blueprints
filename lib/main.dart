import 'package:augmented_reaility/ui/ar_main_page.dart';
import 'package:augmented_reaility/ui/qr_page.dart';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QR(),
      debugShowCheckedModeBanner: false,
    );
  }
}
///Earth model below
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  ArCoreController arcoreController;

  void _onArCoreViewCreated(ArCoreController controller) {
    arcoreController = controller;
    arcoreController.onNodeTap = (name) => onTapHandler(name);
    arcoreController.onPlaneTap = _handleOnPlaneTap;

  }

  void _addSphere(ArCoreHitTestResult plane) {
    final moonMaterial = ArCoreMaterial(color: Colors.grey, texture: "moon.jpg");


    final moonShape = ArCoreSphere(
      materials: [moonMaterial],
      radius: 0.03,
    );

    final moon = ArCoreRotatingNode(
      name: "Moon",
      shape: moonShape,

      position: vector.Vector3(0.89, 0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );







    final earthMaterial = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244), texture: "earth.jpg");

    final earthShape = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.1,
    );

    final earth = ArCoreRotatingNode(
      shape: earthShape,
      name: "Earth",
      position: vector.Vector3(0.7, 0.0, 0.0),

      rotation: vector.Vector4(0, 0, 0, 0),);


    final sunMaterial = ArCoreMaterial(color: Colors.deepOrange, texture: "sun.jpg");

    final sunShape = ArCoreSphere(
      materials: [sunMaterial],
      radius: 0.2,
    );


    final sun = ArCoreRotatingNode(
      shape: sunShape,
      name: "Sun",

      position: vector.Vector3(0, 0.0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );



    final centerMaterial = ArCoreMaterial(color: Colors.transparent);

    final centerShape = ArCoreSphere(
      materials: [centerMaterial],
      radius: 0.0,
    );
    final center =ArCoreNode(
      shape: centerShape,
      children: [moon,earth,sun],

      position: plane.pose.translation + vector.Vector3(0, 0.3, 0),
      rotation: plane.pose.rotation,

    );


    sun.degreesPerSecond.value=20;
    earth.degreesPerSecond.value=30;
    moon.degreesPerSecond.value=70;


    arcoreController.addArCoreNodeWithAnchor(center);


  }


  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addSphere(hit);
  }

  void onTapHandler(String name) {
    print("Flutter: onNodeTap");
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('$name')),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    arcoreController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),

    );
  }
}


class Parent extends StatefulWidget {
  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  @override
  Widget build(BuildContext context) {
    return Button(
        (){
          setState(() {
            ///define your logic here
          });
        }
    );
  }
}

class Button extends StatelessWidget {
  final Function onTap;
  Button(this.onTap);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onTap,
    );
  }
}
