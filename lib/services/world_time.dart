import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class WorldTime {
  late String location; // location name for UI
  late String time; // time in that location
  late String flag; // url to an asset flag icon
  late String url; // location url for api endpoint
  late bool isDaytime; // true or false if daytime or not
  String? countryCode; // country code for flag (US, UK)

  WorldTime({
    required this.location,
    required this.flag,
    required this.url,
    this.countryCode,
  });

  /// Derives a readable country name from the flag filename.
  String get countryName {
    // Basic normalization: 'democratic_republic_of_congo.png' -> 'Democratic Republic Of Congo'
    String name = flag.split('.').first;
    return name.split('_').map((word) {
      if (word.isEmpty) return '';
      // Special cases for acronyms
      if (word.toLowerCase() == 'usa') return 'USA';
      if (word.toLowerCase() == 'uk') return 'UK';
      if (word.toLowerCase() == 'uae') return 'UAE';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  /// Main entry point to fetch data for the location.
  Future<void> getTime() async {
    // We run these sequentially to ensure basic time data is loaded first,
    // though they could technically be parallelized if needed.
    await _fetchTimeData();
    await _fetchCountryCode();
  }

  /// Fetches the current time for the specified [url] timezone.
  Future<void> _fetchTimeData() async {
    try {
      final Response response = await get(
        Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=$url'),
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      time = (data['time'] as String?) ?? '00:00';

      final int hour = (data['hour'] as int?) ?? 0;
      isDaytime = hour >= 6 && hour < 18;

      if (kDebugMode) {
        print('Time data fetched for $location: $time');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching time data: $e');
      }
      time = 'Error 😔';
      isDaytime = false;
    }
  }

  /// Attempts to find a matching country code for the flag asset.
  Future<void> _fetchCountryCode() async {
    try {
      final Response response = await get(
        Uri.parse('https://flagcdn.com/en/codes.json'),
      );

      if (response.statusCode != 200) return;

      final Map<String, dynamic> flagData = jsonDecode(response.body) as Map<String, dynamic>;

      // Basic normalization: 'uk.png' -> 'Uk'
      String countryName = flag.split('.').first;
      countryName = countryName[0].toUpperCase() + countryName.substring(1);

      for (final String key in flagData.keys) {
        if (flagData[key] == countryName) {
          countryCode = key;
          break;
        }
      }

      if (countryCode != null) {
        if (kDebugMode) {
          print('Found country code for $location: $countryCode');
        }
      }
    } catch (e) {
      // Flag lookup is non-critical, so we just log the failure.
      if (kDebugMode) {
        print('Flag lookup failed: $e');
      }
    }
  }
}
