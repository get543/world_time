import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

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

  Future<void> getTime() async {
    try {
      final Response response = await get(
        Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=$url'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load time for $url: ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      final String rawTime = (data['time'] as String?) ?? '00:00';
      final int hour = (data['hour'] as int?) ?? 0;

      time = rawTime;
      isDaytime = hour >= 6 && hour < 18;

      if (kDebugMode) {
        print('Fetched time for $location: $time (${data['timeZone'] ?? url})');
      }

      // Keep the country lookup logic for flag metadata, but do not block the time fetch.
      try {
        final Response flagResponse = await get(
          Uri.parse('https://flagcdn.com/en/codes.json'),
        );

        if (flagResponse.statusCode == 200) {
          final Map<String, dynamic> flagData = jsonDecode(flagResponse.body) as Map<String, dynamic>;

          String countryName = flag.split('.').first;
          countryName = countryName[0].toUpperCase() + countryName.substring(1);
          String? foundCountryCode;

          for (String key in flagData.keys) {
            if (flagData[key] == countryName) {
              foundCountryCode = key;
              break;
            }
          }

          if (kDebugMode) {
            print('Found code: $foundCountryCode');
          }

          countryCode = foundCountryCode;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Skipped flag lookup: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Caught an error: $e');
      }
      time = 'could not get time data';
      isDaytime = false;
    }
  }
}
