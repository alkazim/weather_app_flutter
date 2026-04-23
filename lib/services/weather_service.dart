import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "9eeb8cb789b7a9411f08cc74b395b722";

  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        throw Exception("City not found");
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      throw Exception("Failed to fetch weather");
    }
  }
}