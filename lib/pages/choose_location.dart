import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:world_time/services/locations_data.dart'; // original list
import 'package:world_time/services/world_time.dart';

import 'loading.dart';

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

    if (!mounted) return;

    // *navigate to home screen
    // Return to the previous screen (Home) and pass the data back
    Navigator.pop(context, { // pop the current stack, because the home screen is stacking on top of choose location
      "location": instance.location, // passing data in world_time.dart or in this file
      "flag": instance.flag,
      "time": instance.time,
      "isDayTime": instance.isDaytime,
    });

    // *navigate to the loading screen
    // *passing the arguments needed based on index to loading.dart
    // Navigator.pushReplacementNamed(
    //   context,
    //   "/home",
    //   arguments: {
    //     "location": instance.location,
    //     // passing data in world_time.dart or in this file
    //     "flag": instance.flag,
    //     "time": instance.time,
    //     "isDayTime": instance.isDaytime,
    //   },
    // );
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
      results = locations
          .where(
            (country) => country.location.toLowerCase().contains(
              enteredKeyword.toLowerCase(),
            ),
          )
          .toList();
    }
    setState(() {
      _foundLocations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If 'loading' is true, show the Loading widget; otherwise, show the Scaffold
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              iconTheme: IconThemeData(color: Colors.grey[200]),
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
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                      labelText: "Search",
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _foundLocations.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            onTap: () async {
                              // setState requires the class to extend State<YourWidget>
                              setState(() => loading = true);
                              updateTime(index);
                            },
                            title: Text(
                              _foundLocations[index].location,
                              style: const TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child:
                                    _foundLocations[index].countryCode != null
                                    ? CountryFlag.fromCountryCode( // use flag with country code
                                        _foundLocations[index].countryCode!,
                                        height: 40,
                                        width: 40,
                                      )
                                    : Image.asset( // Use flag in the assets/flag folder
                                        "assets/flag/${_foundLocations[index].flag}",
                                        fit: BoxFit.cover,
                                        height: 40,
                                        width: 40,
                                        errorBuilder: // show unknown flag
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                  "assets/flag/unknown.png",
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
