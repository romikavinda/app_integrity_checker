import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:app_integrity_checker/app_integrity_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _checksum = "";
  String _signature = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        initPlatformState();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String checksum = "";
    String signature = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      checksum = await AppIntegrityChecker.getchecksum() ??
          "checksum retrieval failed";
      signature = await AppIntegrityChecker.getsignature() ??
          "signature retrieval failed";
    } on PlatformException {
      //platform call failed
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _checksum = checksum;
      _signature = signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 150,
                ),
                const Text('App Checksum Value'),
                const SizedBox(
                  height: 10,
                ),
                Text('$_checksum\n'),
                const SizedBox(
                  height: 20,
                ),
                const Text('App Signature Value'),
                const SizedBox(
                  height: 10,
                ),
                Text('$_signature\n'),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
