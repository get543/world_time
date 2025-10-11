
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'loading.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/services/locations_data.dart'; // original list


class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  bool loading = false;

  void updateTime(index) async {
    WorldTime instance = _foundLocations[index];
    await instance.getTime(); // get time of selected index

    setState(() => loading = false); // set loading state to false

    // *navigate to home screen
    // Navigator.pop(context, { // pop the current stack, because the home screen is stacking on top of choose location
    //   "location": instance.location, // passing data in world_time.dart or in this file
    //   "flag": instance.flag,
    //   "time": instance.time,
    //   "isDayTime": instance.isDaytime,
    // });

    // *navigate to the loading screen
    // *passing the arguments needed based on index to loading.dart
    Navigator.pushReplacementNamed(context, "/home", arguments: {
      "location": instance.location, // passing data in world_time.dart or in this file
      "flag": instance.flag,
      "time": instance.time,
      "isDayTime": instance.isDaytime,
    });
  }

  List<WorldTime> _foundLocations = []; // found value

  @override
  void initState() {
    _foundLocations = locations; // set the state
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<WorldTime> results = [];

    // if the search field is empty or
    // only contains white-space, we'll display all locations (og list)
    if (enteredKeyword.isEmpty) {
      results = locations;
    } else {
      // use toLowerCase() to make it case-insensitive
      results = locations.where((country) =>
          country.location.toLowerCase().contains(enteredKeyword.toLowerCase())
      ).toList();
    }
    setState(() {
      _foundLocations = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    // Runs everytime it needs to build the widget tree,
    // it also runs everytime widget data changed (dynamic data on widget)

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar( // If comes from different screen, automatically adds a back button
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData( // change icon theme
          color: Colors.grey[200],
        ),
        title: Text(
          "Choose a Location",
          style: TextStyle(
            color: Colors.grey[200],
            fontFamily: "Roboto",
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _foundLocations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Card(
                      child: ListTile(
                        onTap: () async {
                          setState(() => loading = true); // set loading state
                          updateTime(index);
                        },
                        title: Text(
                          _foundLocations[index].location,
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        leading: CircleAvatar(
                          // backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/flag/${_foundLocations[index].flag}",
                              fit: BoxFit.cover,
                              width: 60, // Ensure the image has a size to fill the circle
                              height: 60,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to default.png if the original asset fails to load
                                return Image.asset(
                                  "assets/flag/unknown.png",
                                  fit: BoxFit.cover,
                                );
                                return Image.network(
                                  "https://flagcdn.com/h60/${_foundLocations[index].flag}",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
