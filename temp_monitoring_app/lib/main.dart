import 'package:flutter/material.dart';
import 'login_page.dart';
import 'stats_screen.dart';
import 'fan_control.dart';
import 'temp_stats.dart';
import 'fan_stats.dart';
import 'temp_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    MyHomePage.tag: (context) => MyHomePage(),
    FanControlPage.tag: (context) => FanControlPage(),
    TempStatsPage.tag: (context) => TempStatsPage(),
    FanStatsPage.tag: (context) => FanStatsPage(),
   //PointsLineChart.tag: (context) => PointsLineChart.withRandomData(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Monitoring',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}


