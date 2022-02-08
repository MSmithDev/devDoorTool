import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Door Dev Tools'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Slider Vars
  double _currentSetpoint = 0;
  double _pVal = 0;
  double _iVal = 0;
  double _dVal = 0;

  bool isConnected = false;

  var channel = IOWebSocketChannel.connect(Uri.parse('ws://localhost:9001'));

  @override
  void initState() {
    channel.stream.listen((event) {
      setState(() {
        isConnected = true;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  void updateSetpoint(double value) {
    channel.sink.add(value.toString());
    setState(() {
      _currentSetpoint = value;
    });
  }

  void updatePval(double value) {
    channel.sink.add(value.toString());
    setState(() {
      _pVal = value;
    });
  }

  void updateIval(double value) {
    channel.sink.add(value.toString());
    setState(() {
      _iVal = value;
    });
  }

  void updateDval(double value) {
    channel.sink.add(value.toString());
    setState(() {
      _dVal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100,
                    height: 60,
                    child: Center(child: Text("Websocket")),
                    color: isConnected ? Colors.green : Colors.red,
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: Center(child: Text("Limit A")),
                    color: false ? Colors.green : Colors.red,
                  ),
                  Container(
                    width: 100,
                    height: 60,
                    child: Center(child: Text("Limit B")),
                    color: false ? Colors.green : Colors.red,
                  )
                ],
              ),
              Text("Door Setpoint: ${_currentSetpoint.round()}"),
              Slider(
                value: _currentSetpoint,
                max: 100,
                label: _currentSetpoint.round().toString(),
                onChanged: updateSetpoint,
              ),
              Text("Door Current: ${_currentSetpoint.round()}"),
              SizedBox(
                height: 50,
                child: LinearProgressIndicator(
                  value: _currentSetpoint * .01,
                ),
              ),
              Text("PID Settings:"),
              Row(children: [
                SizedBox(width: 40, child: Text("P: ${_pVal.round()}")),
                Expanded(
                  child: Slider(
                    value: _pVal,
                    max: 100,
                    label: _pVal.round().toString(),
                    onChanged: updatePval,
                  ),
                ),
              ]),
              Row(children: [
                SizedBox(width: 40, child: Text("I: ${_iVal.round()}")),
                Expanded(
                  child: Slider(
                    value: _iVal,
                    max: 100,
                    label: _iVal.round().toString(),
                    onChanged: updateIval,
                  ),
                ),
              ]),
              Row(children: [
                SizedBox(width: 40, child: Text("D: ${_dVal.round()}")),
                Expanded(
                  child: Slider(
                    value: _dVal,
                    max: 100,
                    label: _dVal.round().toString(),
                    onChanged: updateDval,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
