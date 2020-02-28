import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'stats_screen.dart';

class LoginResponse {
  final String status;
  final String message;

  LoginResponse({this.status, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({this.username, this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json){
    return LoginRequest(
      username: json['username'],
      password: json['password'],
    );
  }
  Map toMap() {
    var map = Map<String, dynamic>();
    map["username"] = username;
    map["password"]= password;

    return map;
  }
}

Future<LoginRequest> createRequest(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return LoginRequest.fromJson(json.decode(response.body));
  });
}


class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final LOGIN_REQUEST_URL = 'https://rmsf2019jvva.appspot.com/users/login';
  //static final LOGIN_REQUEST_URL = 'https://jsonplaceholder.typicode.com/posts';
  //static final LOGIN_REQUEST_URL = 'http://192.168.43.242:3000/users/login';


  TextEditingController emailControler = TextEditingController();
  TextEditingController passControler = TextEditingController();
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

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailControler,
      decoration:InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      controller: passControler,
      obscureText: true,
      decoration:InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)
        ),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),

        onPressed: () async {
          LoginRequest newRequest = LoginRequest(
            username: emailControler.text,
            password: passControler.text,
          );

          http.Response r = await http.post(LOGIN_REQUEST_URL, body: newRequest.toMap());
          //http.Response r = await createRequest(LOGIN_REQUEST_URL , body: newRequest.toMap());

          print(r.body);

          LoginResponse resp = LoginResponse.fromJson(json.decode(r.body));
          print(resp.status);
          if(resp.status == "success")
            Navigator.of(context).pushNamed(MyHomePage.tag);
          else {
            emailControler.text = "";
            passControler.text = "";
          }

        },

        /*
        onPressed: () async {
          // set up POST request arguments
          String url = 'https://rmsf2019jvva.appspot.com/users/login';
          Map<String, String> headers = {"Content-type": "application/json"};
          String json = '{"username": ${emailController}, "password": ${passController}}';

          Response response = await post(url, headers: headers, body: json);

          // check the status code for the result
          int statusCode = response.statusCode;

          if (statusCode < 200 || statusCode > 400 || json == null) {
            throw new Exception("Error while fetching data");
          }
          // this API passes back the id of the new item added to the body
          String body = response.body;
          // {
          //   "title": "Hello",
          //   "body": "body text",
          //   "userId": 1,
          //   "id": 101
          // }
          print(body);
          Navigator.of(context).pushNamed(MyHomePage.tag);
        },
        */

        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: (){
        //redirect logic for recover password
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('RMSF Project')
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left:24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel,
          ],
        )
      ),
    );
  }
}
