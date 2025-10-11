// Initial loading screen
// When it loads it redirect to home screen
import 'package:flutter/foundation.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:world_time/pages/choose_location.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

    Map dataFromLocation = {};
    Object? parameters;

  // !DONT NEED THIS, TOO COMPLEX
  // !SETUP (IF YOU WANT TO LAUNCH SPECIFIC LOCATION ON APP START)
  void setupWorldTime() async {
    // Get the arguments passed from either home or choose_location
    // The ?. is a null-aware operator, making it safe if no args are passed.
    // dataFromLocation = ModalRoute.of(context)?.settings.arguments as Map;
    parameters = ModalRoute.of(context)!.settings.arguments as Map; // getting the data
    Map dataFromLocation = jsonDecode(jsonEncode(parameters));

    // url: 'America/Sao_Paulo', location: 'São Paulo', flag: 'brazil.png'
    WorldTime instance = WorldTime(
      url: dataFromLocation["url"],
      location: dataFromLocation["location"],
      flag: dataFromLocation["flag"],
    );

    if (kDebugMode) {
      print(dataFromLocation);
    }

    await instance.getTime();

    // same with pushNamed, but instead it replaces it instead of adding it to the stack
    // redirects to home screen (home.dart)
    Navigator.pushReplacementNamed(context, "/home", arguments: {
      "location": instance.location, // passing data in world_time.dart or in this file
      "flag": instance.flag,
      "time": instance.time,
      "isDayTime": instance.isDaytime,
    });
  }


  @override
  void initState() { // Function that runs first when creating state object
    // TODO: implement initState
    super.initState();
    // setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitChasingDots(
          color: Colors.white,
          size: 80,
        ),
      )
    );
  }
}
