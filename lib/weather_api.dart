import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:msiciliano_weather_app/weather.dart';

class WeatherApi {
  static const String _apiKey = '24a6dca649f96e67e9208954d79b1f85';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/3.0/onecall';

  static Future<Weather?> getWeatherByCityName(String cityName) async {
    final response = await http.get(
        '$_baseUrl?q=$cityName&appid=$_apiKey&units=metric' as Uri);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<Weather?> getWeatherByLocation(double lon, double lat) async {
    final response = await http.get(
        '$_baseUrl?$lat=50&lon=75&appid=$_apiKey&units=metric' as Uri);


    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }


}