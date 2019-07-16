import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:herow/herow.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _optinUserDataStatus = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Herow.setCustomId("test@connecthings.com");
    Herow.removeCustomId();
    
    bool optinUserDataStatus;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      if (await Herow.optinsNeverAsked) {
        //Update the optin
        Herow.updateOptin(OPTIN_TYPE.USER_DATA, true);
        //Notify the sdk that there is no more optin to update
        Herow.allOptinsAreUpdated();
      }
      optinUserDataStatus = await Herow.isOptinAuthorized(OPTIN_TYPE.USER_DATA);
    } on PlatformException {

    }

    Herow herow = Herow();
    herow.inAppActionEvents.listen((data) {
      print("data is data:" + data.id);
      print("data is data:" + data.status.toString());
    }, onDone: () {
      print("done is done");
    }, onError: (error) {
      print("error is error");
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _optinUserDataStatus = optinUserDataStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('optin data status: $_optinUserDataStatus\n'),
        ),
      ),
    );
  }
}
