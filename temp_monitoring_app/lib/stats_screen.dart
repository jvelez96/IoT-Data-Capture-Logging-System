import 'package:flutter/material.dart';
import 'fan_control.dart';
import 'temp_stats.dart';
import 'fan_stats.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StatsResponse {
  final int temperature;
  final int fan_status;
  final int curr_limit;

  StatsResponse({this.temperature, this.fan_status ,this.curr_limit});

  factory StatsResponse.fromJson(Map<String, dynamic> json){
    return StatsResponse(
      temperature: json['temperature'],
      fan_status: json['fan_status'],
      curr_limit: json['curr_limit'],
    );
  }
}

class MyHomePage extends StatefulWidget {
  static String tag = 'my-home-page';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  int temp;
  int f_status;
  String fan_string;
  int threshold;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  static final STATS_REQUEST_URL = 'https://rmsf2019jvva.appspot.com/measures/last';

  _getMethod() async {

    http.Response response = await http.get(STATS_REQUEST_URL);

    // sample info available in response
    int statusCode = response.statusCode;

    StatsResponse resp = StatsResponse.fromJson(json.decode(response.body));

    temp = resp.temperature;
    f_status = resp.fan_status;
    threshold = resp.curr_limit;

    print(threshold);
    print(temp);
    print(f_status);

    if(f_status==0)
      fan_string = "OFF";
    else
      fan_string = "ON";

    print(fan_string);

    setState(() {});
  }

  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  void initState(){
    // TODO: implement initState
    _getMethod();
    super.initState();
    controller = new TabController(length: 4, vsync: this);

    refreshPage();

    /*
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;*/
  }

  Future<Null> refreshPage() async {
    //refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _getMethod();
    });

    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          key: refreshKey,
          child: ListView(children: <Widget>[
            Column(children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  height: 250.0,
                  width: double.infinity,
                  color: Colors.lightBlueAccent,
                  //Color(getColorHexFromStr('#FDD148')),
                ),
                Positioned(
                  bottom: 250.0,
                  right: 100.0,
                  child: Container(
                    height: 400.0,
                    width: 400.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200.0),
                        color: Color(getColorHexFromStr('#42f4e8')).withOpacity(0.4)),
                  ),
                ),
                Positioned(
                  bottom: 300.0,
                  left: 150.0,
                  child: Container(
                      height: 300.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150.0),
                          color: Color(getColorHexFromStr('#42f4dc'))
                              .withOpacity(0.5))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 15.0),
                        Container(
                          alignment: Alignment.topLeft,
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(37.5),
                              border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                  width: 3.0),
                              image: DecorationImage(
                                  image: AssetImage('assets/logo.png'))),
                        ),
                        //SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'TempControl',
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'The temperature monitoring app',
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                  color: Colors.black.withOpacity(0.7)),
                            )
                          ],
                        ),
                        //SizedBox(width: MediaQuery.of(context).size.width - 275.0),

                        SizedBox(height: 15.0)
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.wifi),
                                color: Colors.white,
                                iconSize: 40.0,
                                onPressed: () {
                                  Navigator.of(context).pushNamed(FanControlPage.tag);
                                },
                              ),
                              Text(
                                'Threshold Set',
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.pie_chart_outlined),
                                color: Colors.white,
                                iconSize: 40.0,
                                onPressed: () {
                                  Navigator.of(context).pushNamed(TempStatsPage.tag);
                                },
                              ),
                              Text(
                                'Temperature Stats',
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.insert_chart),
                                color: Colors.white,
                                iconSize: 40.0,
                                onPressed: () {
                                  Navigator.of(context).pushNamed(FanStatsPage.tag);
                                },
                              ),
                              Text(
                                'Fan Stats',
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        /*
                      Container(
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.print),
                              color: Colors.white,
                              iconSize: 40.0,
                              onPressed: () {},
                            ),
                            Text(
                              'Export Stats',
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                      */
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            cardDetails('Current Temperature', 'assets/logo.png', '${temp}ºC'),
                            cardDetails('Fan Status', 'assets/fan2.png', '${fan_string}'),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            cardDetails('Server Status', 'assets/cloud-server.jpg', 'Online'),
                            cardDetails(
                                'Temperature Threshold', 'assets/thresholdtemp.jpg', '${threshold}ºC'),
                          ],
                        ),
                        SizedBox(height: 5.0)
                      ],
                    )
                  ],
                )
              ]),
              SizedBox(height: 35.0),
              /*listItem('Gift card', Colors.red, Icons.account_box),
            listItem('Bank card', Color(getColorHexFromStr('#E89300')), Icons.credit_card),
            listItem('Replacement code', Color(getColorHexFromStr('#FB8662')), Icons.grid_on),
            listItem('Consulting collection', Colors.blue, Icons.pages),
            listItem('Customer service', Color(getColorHexFromStr('#ECB800')), Icons.person)*/
            ])
          ]),
          onRefresh: refreshPage,
      ),
    );
  }

  Widget listItem(String title, Color buttonColor, iconButton) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: buttonColor.withOpacity(0.3)
            ),
            child: Icon(
                iconButton,
                color: buttonColor,
                size: 25.0
            ),
          ),
          SizedBox(width: 25.0),
          Container(
            width: MediaQuery.of(context).size.width - 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 20.0
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardDetails(String title, String imgPath, String valueCount) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(7.0),
      child: Container(
        height: 125.0,
        width: (MediaQuery.of(context).size.width / 2) - 20.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Image.asset(
                imgPath,
                fit: BoxFit.cover,
                height: 50.0,
                width: 50.0,
              ),
            ),
            SizedBox(height: 2.0),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(title,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 15.0,
                    color: Colors.black,
                  )),
            ),
            SizedBox(height: 3.0),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(valueCount,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 15.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}