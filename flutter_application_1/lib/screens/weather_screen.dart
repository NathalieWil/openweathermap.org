import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String? _weatherInfo;
  String? _weatherIcon;

  Future<void> fetchWeather() async {
    String city = _cityController.text;
    var weatherData = await WeatherService.getWeather(city);

    setState(() {
      _weatherInfo = weatherData['info'] ?? "";
      _weatherIcon = weatherData['icon'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clima en tu ciudad")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: "Ingresa una ciudad",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchWeather,
              child: const Text("Buscar"),
            ),
            const SizedBox(height: 20),
            (_weatherIcon ?? '').isNotEmpty
                ? Image.network(
                  "https://openweathermap.org/img/wn/$_weatherIcon@2x.png",
                )
                : Container(),
            Text(
              _weatherInfo ?? 'No data',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
