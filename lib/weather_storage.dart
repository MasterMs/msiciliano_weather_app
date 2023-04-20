import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather.dart';

class WeatherStorage {
  static const key = 'cachedWeather';

  static Future<void> cacheWeather(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(weatherToJson(weather));
    prefs.setString(key, jsonData);
  }

  static Future<Weather?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(key);
    if (jsonData != null) {
      return jsonToWeather(jsonDecode(jsonData));
    }
    return null;
  }

  static Map<String, dynamic> weatherToJson(Weather weather) {
    return {
      'cityName': weather.cityName,
      'temperature': weather.temperature,
      'description': weather.description,
      'weatherIconCode': weather.weatherIcon.codePoint,
    };
  }

  static Weather jsonToWeather(Map<String, dynamic> json) {
    return Weather(
      cityName: json['cityName'],
      temperature: json['temperature'],
      description: json['description'],
      weatherIcon: IconData(json['weatherIconCode'], fontFamily: 'MaterialIcons'),
    );
  }
}