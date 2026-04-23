import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherScreen extends StatelessWidget {
  final String city;

  const WeatherScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final WeatherService service = WeatherService();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder(
            future: service.getWeather(city),
            builder: (context, snapshot) {

              // 🔄 Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // ❌ Error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              // ✅ Data
              final data = snapshot.data!;

              String cityName = data['name'];
              double temp = data['main']['temp'];
              int humidity = data['main']['humidity'];
              String condition = data['weather'][0]['main'];
              String icon = data['weather'][0]['icon'];
              double wind = data['wind']['speed'];

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    // Back button
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Weather",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Expanded(
                      child: Center(
                        child: Container(
                          width: double.infinity,
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

                              Image.network(
                                "https://openweathermap.org/img/wn/$icon@2x.png",
                                height: 100,
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

                              Text(
                                condition,
                                style: const TextStyle(fontSize: 18),
                              ),

                              const SizedBox(height: 25),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(Icons.water_drop, color: Colors.blue),
                                      const SizedBox(height: 5),
                                      const Text("Humidity"),
                                      Text("$humidity%"),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Icon(Icons.air, color: Colors.blue),
                                      const SizedBox(height: 5),
                                      const Text("Wind"),
                                      Text("$wind m/s"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}