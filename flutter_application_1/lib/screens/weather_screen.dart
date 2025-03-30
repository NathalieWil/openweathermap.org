import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/weather_service.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController cityController = TextEditingController();
  String? selectedCity;
  Map<String, dynamic>? weatherData;
  Map<String, dynamic>? forecastData;
  List<String> cities = [];

  void fetchWeather(String city) async {
    var data = await weatherService.getWeather(city);
    var forecast = await weatherService.getForecast(city);
    if (data != null && forecast != null) {
      setState(() {
        weatherData = data;
        forecastData = forecast;
        selectedCity = city;
        if (!cities.contains(city)) {
          cities.add(city);
        }
      });
    }
  }

  List<Widget> buildForecastCards() {
    if (forecastData == null || forecastData!["list"] == null) {
      return [];
    }
    List<dynamic> forecastList = forecastData!["list"].sublist(0, 5);
    return forecastList.map((data) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(data["dt"] * 1000);
      String dayOfWeek = DateFormat('EEEE').format(date);
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(dayOfWeek, style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
              Text("${data["main"]["temp"]}°C"),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedCity != null ? "Clima en $selectedCity" : "Buscar Clima",
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: "Buscar ciudad",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (value) {
                  fetchWeather(value);
                  cityController.clear();
                },
              ),
              SizedBox(height: 10),
              if (cities.isNotEmpty)
                DropdownButton<String>(
                  value: selectedCity,
                  dropdownColor: Colors.white,
                  hint: Text("Selecciona una ciudad"),
                  items:
                      cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(
                            city,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                  onChanged: (newCity) {
                    fetchWeather(newCity!);
                  },
                ),
              SizedBox(height: 20),
              Expanded(
                child:
                    weatherData == null
                        ? Center(
                          child: Text(
                            "Ingresa una ciudad para ver el clima",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${weatherData!["main"]["temp"]}°C",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              weatherData!["weather"][0]["description"],
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 130,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: buildForecastCards(),
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
