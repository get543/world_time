import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  Object? parameters;

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments as Map; // getting the data
    Map data = jsonDecode(jsonEncode(parameters));

    if (kDebugMode) {
      print(data);
    }

    // set background
    String bgImage = data["isDayTime"] ? "day.png" : "night.png";
    Color? bgColor = data["isDayTime"] ? Colors.blue[100] : Colors.indigo[700];
    Color? frColor = data["isDayTime"] ? Colors.grey[900] : Colors.white;

    var orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg/$bgImage"),
              fit: BoxFit.contain,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 450, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // This centers the children vertically
              crossAxisAlignment: CrossAxisAlignment.start, // This centers the children horizontally
              children: <Widget>[
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, "/location"),
                  icon: Icon(
                    Icons.edit_location,
                    color: frColor,
                  ),
                  label: Text(
                    "Edit Location",
                    style: TextStyle(
                      color: frColor,
                      fontFamily: "Roboto",
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      data["location"] ?? "Unknown Location",
                      style: TextStyle(
                        fontSize: 28,
                        letterSpacing: 2,
                        color: frColor,
                        fontFamily: "Roboto",
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  data["time"] ?? "...",
                  style: TextStyle(
                    fontSize: 66,
                    color: frColor,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),), // Moves widgets into safe area
      );

    } else { // portrait
      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/$bgImage"),
                fit: BoxFit.contain,
              )
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 450, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // This centers the children vertically
              crossAxisAlignment: CrossAxisAlignment.center, // This centers the children horizontally
              children: <Widget>[
                TextButton.icon(
                  onPressed: () async {
                    // dynamic result = await Navigator.pushNamed(context, "/location");
                    // if (result != null) {
                    //   setState(() {
                    //     data = {
                    //       "time": result["time"],
                    //       "location": result["location"],
                    //       "isDayTime": result["isDayTime"],
                    //       "flag": result["flag"],
                    //     };
                    //   });
                    // }
                    Navigator.pushNamed(context, "/location");
                  },
                  icon: Icon(
                    Icons.edit_location,
                    color: frColor,
                  ),
                  label: Text(
                    "Edit Location",
                    style: TextStyle(
                      color: frColor,
                      fontFamily: "Roboto",
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      data["location"] ?? "Unknown Location",
                      style: TextStyle(
                        fontSize: 28,
                        letterSpacing: 2,
                        color: frColor,
                        fontFamily: "Roboto",
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  data["time"] ?? "...",
                  style: TextStyle(
                    fontSize: 66,
                    color: frColor,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),), // Moves widgets into safe area
      );
    }


  }
}
