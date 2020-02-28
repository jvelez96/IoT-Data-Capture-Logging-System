import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'temp_chart.dart';
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

class TempStatsResponse {
  final double temperature;
  final double seconds;


  TempStatsResponse({this.temperature, this.seconds});

  factory TempStatsResponse.fromJson(Map<String, dynamic> json){
    return TempStatsResponse(
      temperature: json['temperature'],
      seconds: json['seconds'],
    );
  }
}

class TempStatsPage extends StatefulWidget {
  static String tag = 'tempstats-page';

  final Widget child;
  TempStatsPage({Key key, this.child}): super(key:key);

  //@override
  _TempStatsPageState createState() => _TempStatsPageState();
}

class _TempStatsPageState extends State<TempStatsPage> {
  List<charts.Series<Temp, double>> _seriesData;
  static final TEMPSTATS_REQUEST_URL = 'https://rmsf2019jvva.appspot.com/measures/tempchart';

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var tempData = [
    new Temp(0.0,0.0),
    new Temp(0.0,0.0),
    new Temp(0.0,0.0),
    new Temp(0.0,0.0),
    new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
  new Temp(0.0,0.0),
    new Temp(0.0,0.0),
  ];

  _getMethod() async {

    http.Response response = await http.get(TEMPSTATS_REQUEST_URL);

    // sample info available in response
    int statusCode = response.statusCode;


    responseBody resp = responseBody.fromJson(json.decode(response.body));
    //print(resp.data);
    //print(response.body);



    //final items = (resp.data['items'] as list)

    var test;
    var i = 1;
    for(var item in resp.data){
      //print(item);
      //print(item["seconds"]);
      var lol = item["temperature"] + 0.0;
      var lol2 = item["seconds"] + 0.0;
      //TempStatsResponse Tresp = TempStatsResponse.fromJson(json.decode(item));
      //test = int.parse(item["temperature"]);
      //assert(test is int);
      //print(test);
      tempData[i].temperature = lol;
      tempData[i].seconds = lol2;
      print(tempData[i].temperature);
      print(tempData[i]);

      i++;
    }



    /*
    TempStatsResponse resp = TempStatsResponse.fromJson(json.decode(response.body));

    List<dynamic> list = json.decode(response.body);
    TempStatsResponse resp = TempStatsResponse.fromJson(list[0]);
    */

    /*
    Map data = JSON.decode(response.body);
    var temp_list = data['items']; //returns a List of Maps
    for (var items in temp_list){ //iterate over the list
      Map myMap = items; //store each map
      print(myMap['snippet']);
    }*/

    //temp = resp.temperature;
    setState(() {});
  }

  _generateData(){
    /*
    var tempData= [
      new Temp(10, 30),
      new Temp(20, 23),
      new Temp(30, 29),
      new Temp(40, 27),
      new Temp(50, 29),
      new Temp(60, 32),
    ];
*/

    _seriesData.add(
      charts.Series(
        data: tempData,
        domainFn: (Temp temp, _)=>temp.seconds,
        measureFn: (Temp temp, _)=>temp.temperature,
        colorFn: (__,_) => charts.MaterialPalette.blue.shadeDefault,
        id: 'Temperature in ºC',
      ),
    );
  }

  @override
  void initState(){
    //check if it works before initState()
    _getMethod();
    super.initState();
    _seriesData = List<charts.Series<Temp, double>>();
    _generateData();
    //refreshPage();
  }

  Future<Null> refreshPage() async {
    //refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
    });

    return null;
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
          title: Text('Temperature Stats')
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Temperature variation of the last 60 seconds',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
              Expanded(
                child: charts.LineChart(
                    _seriesData,
                    defaultRenderer: new charts.LineRendererConfig(
                        includeArea: true, includePoints: true
                    ),
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.ChartTitle('Temperature in ºC',
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