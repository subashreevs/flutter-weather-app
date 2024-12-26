import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherSevice('79f0e9fff4795093aced54e9760e33fa');
  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();

  // Fetch weather for input city
  _fetchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load weather data. Please try again.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo.shade900, // Darker top
              Colors.blueGrey.shade900 // Darker bottom
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // City Input
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    hintText: 'Enter city name',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.location_city, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _fetchWeather(value);
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Fetch Weather Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      _fetchWeather(_cityController.text);
                    }
                  },
                  child: Text('Get Weather', style: TextStyle(fontSize: 16)),
                ),

                const SizedBox(height: 40),

                // Weather Information
                if (_weather != null)
                  Column(
                    children: [
                      // City Name
                      Text(
                        _weather!.cityName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Weather Animation
                      Lottie.asset(
                        getWeatherAnimation(_weather?.mainCondition),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 20),

                      // Temperature
                      Text(
                        '${_weather!.temperature.round()}°C',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Weather Condition
                      Text(
                        _weather!.mainCondition,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )
                else
                  CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
      case 'heavy snow':
      case 'light snow':
        return 'assets/snow.json';
      default:
        return 'assets/sunny.json';
    }
  }
}