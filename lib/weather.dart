import 'package:flutter/material.dart';

class Weather {
  final String description;
  final double temperature;

  Weather({required this.description, required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) {
    String description = json['weather'][0]['description'];
    double temperature = json['main']['temp'].toDouble();

    return Weather(description: description, temperature: temperature);
  }
}