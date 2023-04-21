import 'package:flutter/material.dart';
import 'package:msiciliano_weather_app/weather.dart';
import 'package:msiciliano_weather_app/weather_api.dart';
import 'package:msiciliano_weather_app/location_service.dart';
import 'package:msiciliano_weather_app/weather_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? _weather;
  bool _loading = true;

  final _weatherSearch = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchWeather(0);
  }

  void _fetchWeather(int mode) async {
    final weather;
    try {
      if (mode == 1) {
        weather = await WeatherApi.getWeatherByCityName(_weatherSearch.text);
      }
      else {
        final position = await LocationService.getCurrentLocation();
        weather = await WeatherApi.getWeatherByLocation(position.latitude, position.longitude);
      }

      if (weather != null) {
        await WeatherStorage.cacheWeather(weather);
      }



      setState(() {
        _weather = weather;
        _loading = false;
      });
    } catch (e) {
      final cachedWeather = await WeatherStorage.getCachedWeather();
      if (cachedWeather != null) {
        setState(() {
          _weather = cachedWeather;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _weather == null
              ? Center(child: Text('Failed to load weather data'))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _weather!.cityName,
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Icon(
                        _weather!.weatherIcon,
                        size: 100,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${_weather!.temperature.toStringAsFixed(1)}°C',
                        style: TextStyle(fontSize: 32),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _weather!.description,
                        style: TextStyle(fontSize: 24),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter the City',
                          border: OutlineInputBorder(),
                        ),
                        controller: _weatherSearch,

                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _fetchWeather(1);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          _fetchWeather(0);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}