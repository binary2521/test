// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Battery _battery = Battery();

  BatteryState _batteryState;
  StreamSubscription<BatteryState> _batteryStateSubscription;


  @override
  void initState() {
    super.initState();
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
          setState(() {
            _batteryState = state;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    String finalFee = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoreBinary - Phone Battery Status'),
      ),
      body: Center(
        child: Text('$_batteryState',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.battery_unknown),
        onPressed: () async {
          final int batteryLevel = await _battery.batteryLevel;
          // ignore: unawaited_futures
          showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      if(batteryLevel<=90){
                        // print('Low battery; Please charge your mobile and continue the transaction.');
                        showToast("$batteryLevel% Low battery; Please charge your mobile and continue the transaction.");
                      }
                      else{
                        showToast("Your Mobile battery is $batteryLevel%. Go ahead with the transaction");
                        // print('Your Mobile battery is $batteryLevel%. Go ahead with the transaction');
                      }
                    },
                      child: Text('Battery: $batteryLevel%')),
                //Text('Your phone has sufficicent battery charge to proceed payment',style: TextStyle(fontWeight: FontWeight.bold)),
          ],
              ),
             actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),

          );
          print('$batteryLevel');
        },

      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription.cancel();
    }
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
/*  void _charge() {
    var charge = 87;
    if(charge < 90)
    {
      print('You have sufficient charge');
    }
    else
    {
      print('You Dont have sufficient charge');
    }
  }*/
}