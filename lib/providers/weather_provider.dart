import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String? error;

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      weatherData = await _service.getWeather(city);
    } catch (e) {
      error = "City not available";
      weatherData = null;
    }

    isLoading = false;
    notifyListeners();
  }
}