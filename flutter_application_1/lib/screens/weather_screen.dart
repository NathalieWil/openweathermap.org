import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  String city = "London";
  Map<String, dynamic>? weatherData;
  List<dynamic> forecastData = [];

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  Future<void> fetchWeather(String cityName) async {
    final weather = await _weatherService.getWeather(cityName);
    final forecast = await _weatherService.getForecast(cityName);

    if (weather != null && forecast != null) {
      setState(() {
        weatherData = weather;
        forecastData = forecast["list"].sublist(0, 7); // 7 días de pronóstico
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ciudad no encontrada")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather App")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Buscar ciudad",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                setState(() {
                  city = value;
                });
                fetchWeather(value);
              },
            ),
            SizedBox(height: 20),
            if (weatherData != null) ...[
              Text(
                "${weatherData!["name"]}, ${weatherData!["sys"]["country"]}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Image.network(
                "https://openweathermap.org/img/wn/${weatherData!["weather"][0]["icon"]}@2x.png",
                width: 100,
                height: 100,
              ),
              Text(
                "${weatherData!["main"]["temp"]}°C",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(weatherData!["weather"][0]["description"].toString()),
              SizedBox(height: 20),
              Text(
                "Pronóstico para los próximos 7 días:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecastData.length,
                  itemBuilder: (context, index) {
                    final day = forecastData[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(day["dt_txt"].toString().substring(0, 10)),
                            Image.network(
                              "https://openweathermap.org/img/wn/${day["weather"][0]["icon"]}@2x.png",
                              width: 50,
                              height: 50,
                            ),
                            Text("${day["main"]["temp"]}°C"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
