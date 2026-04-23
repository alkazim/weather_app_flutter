import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  final String city;

  const WeatherScreen({super.key, required this.city});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeather(widget.city);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // 🔹 HEADER (FULL WIDTH)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Weather",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 BODY (CENTERED RESPONSIVE)
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildContent(provider),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(WeatherProvider provider) {

    // 🔄 Loading
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ❌ Error
    if (provider.error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.white, size: 60),
          const SizedBox(height: 10),
          Text(
            provider.error!,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              provider.fetchWeather(widget.city);
            },
            child: const Text("Retry"),
          ),
        ],
      );
    }

    // ✅ Data
    final data = provider.weatherData!;

    String cityName = data['name'];
    double temp = data['main']['temp'];
    int humidity = data['main']['humidity'];
    String condition = data['weather'][0]['main'];
    double wind = data['wind']['speed'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text(
            cityName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Icon(
            condition.toLowerCase().contains("rain")
                ? Icons.umbrella
                : condition.toLowerCase().contains("cloud")
                    ? Icons.cloud
                    : Icons.wb_sunny,
            size: 100,
            color: Colors.blue.shade400,
          ),

          const SizedBox(height: 10),

          Text(
            "${temp.toStringAsFixed(1)}°C",
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(condition),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Icon(Icons.water_drop),
                  const SizedBox(height: 5),
                  const Text("Humidity"),
                  Text("$humidity%"),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.air),
                  const SizedBox(height: 5),
                  const Text("Wind"),
                  Text("$wind m/s"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}