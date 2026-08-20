import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_time/services/locations_data.dart'; // original list
import 'package:world_time/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  bool isLoading = false;
  bool _isAscending = true;
  List<WorldTime> _foundLocations = [];

  @override
  void initState() {
    _foundLocations = List.from(locations);
    _sortLocations();
    super.initState();
  }

  void _sortLocations() {
    setState(() {
      if (_isAscending) {
        _foundLocations.sort((a, b) => a.location.compareTo(b.location));
      } else {
        _foundLocations.sort((a, b) => b.location.compareTo(a.location));
      }
    });
  }

  Future<void> updateTime(int index) async {
    final WorldTime instance = _foundLocations[index];
    await instance.getTime(); // get time of selected index

    if (!mounted) return;

    setState(() => isLoading = false);

    // Return to the previous screen (Home) and pass the selected timezone data back.
    Navigator.pop(context, <String, dynamic>{
      "location": instance.location,
      "flag": instance.flag,
      "url": instance.url,
      "time": instance.time,
      "isDayTime": instance.isDaytime,
    });
  }

  void _runFilter(String enteredKeyword) {
    List<WorldTime> results = [];

    // if the search field is empty or
    // only contains white-space, we'll display all locations (og list)
    if (enteredKeyword.isEmpty) {
      results = List.from(locations);
    } else {
      // use toLowerCase() to make it case-insensitive
      final String searchLower = enteredKeyword.toLowerCase();
      results = locations.where((item) {
        return item.location.toLowerCase().contains(searchLower) ||
            item.countryName.toLowerCase().contains(searchLower);
      }).toList();
    }

    // Maintain current sort order
    if (_isAscending) {
      results.sort((a, b) => a.location.compareTo(b.location));
    } else {
      results.sort((a, b) => b.location.compareTo(a.location));
    }

    setState(() {
      _foundLocations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D47A1), // Colors.blue[900]
        body: Center(child: SpinKitChasingDots(color: Colors.white, size: 80)),
      );
    }

    return Scaffold(
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
        actions: [
          IconButton(
            onPressed: () {
              _isAscending = !_isAscending;
              _sortLocations();
            },
            icon: Icon(
              _isAscending ? Icons.sort_by_alpha : Icons.sort_by_alpha_outlined,
              color: Colors.grey[200],
            ),
            tooltip: _isAscending ? "Sort Z-A" : "Sort A-Z",
          ),
        ],
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
                        setState(() => isLoading = true);
                        await updateTime(index);
                      },
                      title: Text(
                        _foundLocations[index].location,
                        style: const TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        _foundLocations[index].countryName,
                        style: const TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: _foundLocations[index].countryCode != null
                              ? CountryFlag.fromCountryCode(
                                  _foundLocations[index].countryCode!,
                                  height: 40,
                                  width: 40,
                                )
                              : Image.asset(
                                  "assets/flag/${_foundLocations[index].flag}",
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 40,
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
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
