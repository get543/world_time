
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  void initState() {
    super.initState();
    // This code runs only ONCE when the widget is first built.
    // We use a post-frame callback to ensure the context is fully available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Safely get the arguments passed from the previous screen.
      final arguments = ModalRoute.of(context)?.settings.arguments;

      // IMPORTANT: Check if arguments are not null and are of the correct type.
      if (arguments != null && arguments is Map) {
        setState(() {
          // If they are valid, update our state variable.
          data = arguments;
        });
      } else {
        // Optional: Handle the case where no arguments were passed.
        // You could set default data or show an error.
        if (kDebugMode) {
          print("No arguments received or arguments are not a Map.");
        }
        setState(() {
          data = {'error': 'No data found'};
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if data is empty. If it is, get arguments.
    // This prevents overwriting your data on rebuilds.
    if (data.isEmpty) {
      data = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    }

    // set background
    String bgImage = data["isDayTime"] ? "day.png" : "night.png";
    Color? bgColor = data["isDayTime"] ? Colors.blue[100] : Colors.indigo[700];
    Color? frColor = data["isDayTime"] ? Colors.grey[900] : Colors.white;

    var orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Row(
            children: <Widget>[
              // Left side: Background Image
              Expanded(
                flex: 1,
                child: Image.asset(
                  "assets/bg/$bgImage",
                  fit: BoxFit.cover,
                ),
              ),
              // Right side: Content
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
                            dynamic result = await Navigator.pushNamed(context, "/location");
                            if (result != null) {
                              setState(() {
                                data = {
                                  "time": result["time"],
                                  "location": result["location"],
                                  "isDayTime": result["isDayTime"],
                                  "flag": result["flag"],
                                };
                              });
                            }
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
                        const SizedBox(height: 20),
                        Text(
                          data["location"] ?? "Unknown Location",
                          style: TextStyle(
                            fontSize: 28,
                            letterSpacing: 2,
                            color: frColor,
                            fontFamily: "Roboto",
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data["time"] ?? "...",
                          style: TextStyle(
                            fontSize: 48,
                            color: frColor,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                    // Wait for the user to pick a location and return data
                    dynamic result = await Navigator.pushNamed(context, "/location");

                    if (result != null) {
                      setState(() {
                        data = {
                          "time": result["time"],
                          "location": result["location"],
                          "isDayTime": result["isDayTime"],
                          "flag": result["flag"],
                        };
                      });
                    }
                    // Navigator.pushNamed(context, "/location");
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
