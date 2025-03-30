import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class WeatherService {
  static Future<Map<String, String>> getWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        "info":
            "Ciudad: ${data['name']}\n"
            "Temperatura: ${data['main']['temp']}°C\n"
            "Humedad: ${data['main']['humidity']}%\n"
            "Clima: ${data['weather'][0]['description']}",
        "icon": data['weather'][0]['icon'],
      };
    } else {
      return {
        "info": "No se pudo obtener el clima. Verifica el nombre de la ciudad.",
        "icon": "",
      };
    }
  }
}
