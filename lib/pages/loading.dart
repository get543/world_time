// Initial loading screen
// When it loads it redirect to home screen
import 'package:flutter/foundation.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    parameters = ModalRoute.of(context)?.settings.arguments;
    Map? dataFromLocation = {};

    if (parameters != null && parameters is Map) {
      dataFromLocation = parameters as Map<dynamic, dynamic>?;
    } else {
      // Default location on app start
      dataFromLocation = {'url': 'Asia/Jakarta', 'location': 'Jakarta', 'flag': 'indonesia.png'};
    }

    WorldTime instance = WorldTime(
      url: dataFromLocation?['url'],
      location: dataFromLocation?['location'],
      flag: dataFromLocation?['flag'],
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
    super.initState();
    // Use addPostFrameCallback to ensure context is available for ModalRoute
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupWorldTime();
    });
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
