// Initial loading screen
// When it loads it redirect to home screen
import 'package:world_time/services/world_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setupWorldTime() async {
    final Object? params = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> locationData;

    if (params is Map<String, dynamic>) {
      locationData = params;
    } else {
      locationData = <String, dynamic>{
        'url': 'Asia/Jakarta',
        'location': 'Jakarta',
        'flag': 'indonesia.png',
      };
    }

    final String wtUrl = locationData['url'] as String;
    final String wtLocation = locationData['location'] as String;
    final String wtFlag = locationData['flag'] as String;

    final WorldTime instance = WorldTime(
      url: wtUrl,
      location: wtLocation,
      flag: wtFlag,
    );

    await instance.getTime();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      "/home",
      arguments: <String, dynamic>{
        "location": instance.location,
        "flag": instance.flag,
        "time": instance.time,
        "isDayTime": instance.isDaytime,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupWorldTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D47A1), // Colors.blue[900]
      body: Center(child: SpinKitChasingDots(color: Colors.white, size: 80)),
    );
  }
}
