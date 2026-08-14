import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, dynamic> _data = <String, dynamic>{};
  Timer? _refreshTimer;

  void _refreshTime() async {
    final String url = (_data['url'] as String?) ?? 'Asia/Jakarta';
    final String location = (_data['location'] as String?) ?? 'Jakarta';
    final String flag = (_data['flag'] as String?) ?? 'indonesia.png';

    final WorldTime instance = WorldTime(
      url: url,
      location: location,
      flag: flag,
    );

    await instance.getTime();

    if (!mounted) return;

    setState(() {
      _data['time'] = instance.time;
      _data['isDayTime'] = instance.isDaytime;
    });
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshTime();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Object? arguments = ModalRoute.of(context)?.settings.arguments;

      if (arguments is Map<String, dynamic>) {
        setState(() {
          _data.addAll(arguments);
        });
        _startAutoRefresh();
      } else {
        if (kDebugMode) {
          print('No arguments received or arguments are not a Map.');
        }
        setState(() {
          _data['error'] = 'No data found';
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      final Object? args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _data.addAll(args);
        _startAutoRefresh();
      }
    }

    final bool isDayTime = _data['isDayTime'] == true;
    final String bgImage = isDayTime ? 'day.png' : 'night.png';
    final Color? bgColor = isDayTime ? Colors.blue[100] : Colors.indigo[700];
    final Color? frColor = isDayTime ? Colors.grey[900] : Colors.white;

    final Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Image.asset("assets/bg/$bgImage", fit: BoxFit.cover),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          onPressed: () async {
                            final dynamic result = await Navigator.pushNamed(
                              context,
                              "/location",
                            );
                            if (result is Map<String, dynamic>) {
                              setState(() {
                                _data["time"] = result["time"];
                                _data["location"] = result["location"];
                                _data["isDayTime"] = result["isDayTime"];
                                _data["flag"] = result["flag"];
                                _data["url"] = result["url"] ?? _data["url"];
                              });
                              _startAutoRefresh();
                            }
                          },
                          icon: Icon(Icons.edit_location, color: frColor),
                          label: Text(
                            "Edit Location",
                            style: TextStyle(
                              color: frColor,
                              fontFamily: "Roboto",
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          (_data["location"] as String?) ?? "Unknown Location",
                          style: TextStyle(
                            fontSize: 28,
                            letterSpacing: 2,
                            color: frColor,
                            fontFamily: "Roboto",
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          (_data["time"] as String?) ?? "...",
                          style: TextStyle(
                            fontSize: 48,
                            color: frColor,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/$bgImage"),
                fit: BoxFit.contain,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 450, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () async {
                      final dynamic result = await Navigator.pushNamed(
                        context,
                        "/location",
                      );

                      if (result is Map<String, dynamic>) {
                        setState(() {
                          _data["time"] = result["time"];
                          _data["location"] = result["location"];
                          _data["isDayTime"] = result["isDayTime"];
                          _data["flag"] = result["flag"];
                          _data["url"] = result["url"] ?? _data["url"];
                        });
                        _startAutoRefresh();
                      }
                    },
                    icon: Icon(Icons.edit_location, color: frColor),
                    label: Text(
                      "Edit Location",
                      style: TextStyle(
                        color: frColor,
                        fontFamily: "Roboto",
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        (_data["location"] as String?) ?? "Unknown Location",
                        style: TextStyle(
                          fontSize: 28,
                          letterSpacing: 2,
                          color: frColor,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (_data["time"] as String?) ?? "...",
                    style: TextStyle(
                      fontSize: 66,
                      color: frColor,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
