import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController cityController = TextEditingController();
  String selectedCity = "Bogotá";
  Map<String, dynamic>? weatherData;
  List<String> cities = [
    "Bogotá",
    "Medellín",
    "Cali",
    "Barranquilla",
    "Cartagena",
  ];

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    var data = await weatherService.getWeather(selectedCity);
    setState(() {
      weatherData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clima en $selectedCity")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "Buscar ciudad",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCity,
              items:
                  cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
              onChanged: (newCity) {
                setState(() {
                  selectedCity = newCity!;
                  fetchWeather();
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child:
                  weatherData == null
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${weatherData!["main"]["temp"]}°C",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            weatherData!["weather"][0]["description"],
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Día ${index + 1}"),
                                        Icon(Icons.wb_sunny, size: 40),
                                        Text("25°C"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
