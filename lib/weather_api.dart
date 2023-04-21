import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:msiciliano_weather_app/weather.dart';

class WeatherApi {
  static const apiKey = '24a6dca649f96e67e9208954d79b1f85';
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> getWeatherByLocation(double lat, double lon) async {
    final response = await http.get(Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return parseWeatherData(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

    static Future<Weather> getWeatherByCityName(String cityName) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return parseWeatherData(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  static Weather parseWeatherData(Map<String, dynamic> jsonData) {
    final cityName = jsonData['name'];
    final temperature = jsonData['main']['temp'];
    final description = jsonData['weather'][0]['description'];
    final weatherIconCode = jsonData['weather'][0]['icon'];
    final weatherIcon = getWeatherIcon(weatherIconCode);
    return Weather(cityName: cityName, temperature: temperature, description: description, weatherIcon: weatherIcon);
  }

  static IconData getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return Icons.wb_sunny;
      case '01n':
        return Icons.nightlight_round;
      // Add more cases for other icons...
      default:
        return Icons.cloud;
    }
  }
}