import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';

class WorldTime {
  late String location; // location name for UI
  late String time; // time in that location
  late String flag; // url to an asset flag icon
  late String url; // location url for api endpoint
  late bool isDaytime; // true or false if daytime or not
  String? countryCode;

  WorldTime({
    required this.location,
    required this.flag,
    required this.url,
    this.countryCode,
  });

  // like a promise in JS (placeholder value until async function is complete
  Future<void> getTime() async {
    try {
      //! https://worldtimeapi.org/api/timezone/Asia/Jakarta (doesn't work btw)
      //! https://timeapi.io/api/Time/current/zone?timeZone=America/New_York
      Response response = await get(Uri.parse("https://timeapi.io/api/Time/current/zone?timeZone=$url")); // store response in an object
      Map data = jsonDecode(response.body); // decode response into a json then we can use map to get the property
      // Map<String, dynamic> data = jsonDecode(response.body); // same thing but using dynamic and define the string data type
      // print(data);

      // !FLAG (NOT IN USE)
      Response flagResponse = await get(Uri.parse("https://flagcdn.com/en/codes.json"));
      Map flagData = jsonDecode(flagResponse.body);


      String countryName = flag.split('.').first;
      countryName = countryName[0].toUpperCase() + countryName.substring(1);
      String? countryCode;

      // Iterate through every key in the map
      for (String key in flagData.keys) {
        // Check if the value for that key matches our country name
        if (flagData[key] == countryName) {
          countryCode = key; // We found it!
          break; // Exit the loop since we don't need to search anymore
        }
      }

      if (kDebugMode) {
        print("Found code: $countryCode"); // Will print "Found code: ch"
      }

      // *only use this with timeapi.io api
      isDaytime = data["hour"] > 6 && data["hour"] < 18 ? true : false; // 6:00 - 17:59
      time = data["time"];

    } catch (e) {
      if (kDebugMode) {
        print("Caught an error: $e");
      }
      time = "could not get time data";
      isDaytime = false;
    }
  }


  // !testing fetch api (unused)
  void getData() async { // used for testing api
    /* !If it returns an HTML page (Cloudflare), yeah you are fucked! */
    /* !The data response is represented in strings (JSON represented as strings) */
    Response response = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1")); // store response in an object
    Map data = jsonDecode(response.body); // decode response into a json then we can use map to get the property
    // List< dynamic> data = jsonDecode(response.body); // same thing but using dynamic and define the string data type
    if (kDebugMode) {
      print(data);
    }
  }

}
