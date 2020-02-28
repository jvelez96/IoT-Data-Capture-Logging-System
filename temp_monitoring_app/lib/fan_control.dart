import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ThresholdSet {
  String threshold;

  ThresholdSet({this.threshold});

  factory ThresholdSet.fromJson(Map<String, dynamic> json){
    return ThresholdSet(
      threshold: json['threshold'],
    );
  }
  Map toMap() {
    var map = Map<String, dynamic>();
    map["threshold"] = threshold;

    return map;
  }
}

class FanControlPage extends StatefulWidget {
  static String tag = 'fancontrol-page';
  @override
  _FanControlPageState createState() => _FanControlPageState();
}

class _FanControlPageState extends State<FanControlPage> {
  double _value = 0.0;
  static final THRESHOLD_URL = 'https://rmsf2019jvva.appspot.com/measures/threshold';
  void _setvalue(double value) => setState(() => _value = value);

  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/fan2.png'),
      ),
    );

    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),

        onPressed: ()async {
          ThresholdSet newThreshold = ThresholdSet(
            threshold: ((_value * 40).round().toString()),
          );

          await http.post(THRESHOLD_URL, body: newThreshold.toMap());
          print(newThreshold.toMap());
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Submit', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Control')
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left:24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              new Text('Turn fan on at (ºC): ${(_value * 40).round()}'),
              new Slider(value: _value, onChanged: _setvalue),
              submitButton
            ],
          )
      ),
    );
  }
}