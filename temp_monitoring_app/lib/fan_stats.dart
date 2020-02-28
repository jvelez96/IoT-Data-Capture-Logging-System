import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class responseBody {
  final String status;
  final List<dynamic> data;

  responseBody({this.status, this.data});

  factory responseBody.fromJson(Map<String, dynamic> json){
    return responseBody(
      status: json['status'],
      data: json['data'],
    );
  }
}


class FanStatsPage extends StatefulWidget {
  static String tag = 'fanstats-page';

  final Widget child;
  FanStatsPage({Key key, this.child}): super(key:key);

  //@override
  _FanStatsPageState createState() => _FanStatsPageState();
}

class _FanStatsPageState extends State<FanStatsPage> {
  List<charts.Series<Fan, double>> _seriesData;
  static final FANSTATS_REQUEST_URL = 'https://rmsf2019jvva.appspot.com/measures/fanchart';

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var fanData = [
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
    new Fan(0.0,0.0),
  ];

  _getMethod() async {

    http.Response response = await http.get(FANSTATS_REQUEST_URL);

    // sample info available in response
    int statusCode = response.statusCode;

    responseBody resp = responseBody.fromJson(json.decode(response.body));

    var test;
    var i = 1;
    for(var item in resp.data){

      var lol = item["fan_status"] + 0.0;
      var lol2 = item["seconds"] + 0.0;

      fanData[i].fan_status = lol;
      fanData[i].seconds = lol2;
      print(fanData[i].fan_status);

      i++;
    }

    setState(() {});
  }
  _generateData(){
    /*
    var fanData= [
      new Fan(10, 0),
      new Fan(20, 1),
      new Fan(30, 1),
      new Fan(40, 0),
      new Fan(50, 0),
      new Fan(60, 0),
    ];
    */
    _seriesData.add(
      charts.Series(
        data: fanData,
        domainFn: (Fan fan, _)=>fan.seconds,
        measureFn: (Fan fan, _)=>fan.fan_status,
        colorFn: (__,_) => charts.MaterialPalette.blue.shadeDefault,
        id: 'Minutes the fan was on',
      ),
    );
  }

  @override
  void initState(){
    _getMethod();
    super.initState();
    _seriesData = List<charts.Series<Fan, double>>();
    _generateData();
  }
  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
          title: Text('Fan Stats')
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Periods the fan was on',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                Expanded(
                  child: charts.LineChart(
                      _seriesData,
                      defaultRenderer: new charts.LineRendererConfig(
                          includeArea: true, includePoints: true
                      ),
                      animate: true,
                      animationDuration: Duration(seconds: 5),
                      behaviors: [
                        new charts.ChartTitle('Periods Fan was turned on',
                          behaviorPosition: charts.BehaviorPosition.end,
                          titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Fan {
  double seconds;
  double fan_status;

  Fan(this.seconds, this.fan_status);
}