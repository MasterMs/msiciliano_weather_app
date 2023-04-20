import 'package:flutter/material.dart';
import 'package:msiciliano_weather_app/location_screen.dart';
import 'package:msiciliano_weather_app/weather.dart';
import 'package:msiciliano_weather_app/weather_api.dart';

class HomeScreen extends StatefulWidget {
  final List<String> locations;

  HomeScreen({required this.locations});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _loadWeather(widget.locations.first);
  }

  void _loadWeather(String location) async {
    Weather? weather = await WeatherApi.getWeatherByCityName(location);
    setState(() {
      _weather = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_location),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationScreen(
                    locations: widget.locations,
                  ),
                ),
              );
              if (result != null) {
                _loadWeather(result);
              }
            },
          ),
        ],
      ),
      body: _weather == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _weather!.cityName,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _weather!.weatherIcon,
                      size: 50,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${_weather!.temperature.toStringAsFixed(1)}°C',
                      style: TextStyle(fontSize: 48),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  _weather!.description.toUpperCase(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }
}