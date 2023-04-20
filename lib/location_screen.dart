import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:msiciliano_weather_app/weather.dart';
import 'package:msiciliano_weather_app/weather_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationsScreen extends StatefulWidget {
  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  List<String> _locations = [];
  Map<String, Weather> _weatherData = {};

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> locations = prefs.getStringList('locations') ?? [];
    String weatherDataJson = prefs.getString('weatherData') ?? '{}';

    Map<String, Weather> weatherData = {};
    Map<String, dynamic> decodedWeatherData = jsonDecode(weatherDataJson);
    decodedWeatherData.forEach((key, value) {
      weatherData[key] = Weather.fromJson(value);
    });

    setState(() {
      _locations = locations;
      _weatherData = weatherData;
    });
  }

  Future<void> _saveLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('locations', _locations);
    String weatherDataJson = jsonEncode(_weatherData);
    await prefs.setString('weatherData', weatherDataJson);
  }

  void _addLocation(String location) async {
    Weather? weather = await WeatherApi.getWeatherByCityName(location);
    if (weather != null) {
      setState(() {
        _locations.add(location);
        _weatherData[location] = weather;
      });
      _saveLocations();
    }
  }

  void _removeLocation(int index) {
    setState(() {
      String removedLocation = _locations[index];
      _locations.removeAt(index);
      _weatherData.remove(removedLocation);
    });
    _saveLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _addLocation(value);
                }
              },
              decoration: InputDecoration(
                labelText: 'Add location',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                String location = _locations[index];
                Weather? weather = _weatherData[location];

                return ListTile(
                  title: Text(location),
                  subtitle: weather != null
                      ? Text(
                          '${weather.temperature}°C - ${weather.description}',
                        )
                      : null,
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeLocation(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}