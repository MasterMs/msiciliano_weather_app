import 'package:flutter/material.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final IconData weatherIcon;

  Weather({required this.cityName, required this.temperature, required this.description, required this.weatherIcon});
}