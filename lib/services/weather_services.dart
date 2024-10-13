import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/env/env.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherServices {
  final String _apiKey = Env.weatherKey;
  final String _host = "https://api.openweathermap.org/data/2.5/weather";

  //todo: api call function
  Future<WeatherData?> getWeather(String cityName) async {
    try {
      final response = await http
          .get(Uri.parse('$_host?q=$cityName&appid=$_apiKey&units=metric'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Data not found..!');
      }
    } catch (e) {
      debugPrint('Log => GetWeather : $e');
    }
    return null;
  }

  //todo: device api call
  Future<WeatherData?> weather() async {
    try {
      //? location info
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      //* device latitude & longitude
      double lat = position.latitude, long = position.longitude;

      //* api data call
      final response = await http.get(
          Uri.parse('$_host?lat=$lat&lon=$long&appid=$_apiKey&units=metric'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Data not found..!');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
