import 'package:flutter/material.dart';
import 'package:shake_event/shake_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ShakeHandler {
  @override
  void initState() {
    startListeningShake(20);
    //20 is the default threshold value for the shake event
    super.initState();
  }

  @override
  void dispose() {
    resetShakeListeners();
    super.dispose();
  }

  @override
  shakeEventListener() {
    //DO ACTIONS HERE
    return super.shakeEventListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
