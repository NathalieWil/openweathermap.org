import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "fe65afb6e2986ee1da6de12e3c844ff0";
  final String baseUrl = "api.openweathermap.org";

  Future<Map<String, dynamic>?> getWeather(String city) async {
    try {
      final Uri url = Uri.https(baseUrl, "/data/2.5/weather", {
        "q": city,
        "appid": apiKey,
        "units": "metric",
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey("main")) {
          return data;
        } else {
          throw Exception("Datos no válidos recibidos.");
        }
      } else {
        throw Exception("Error al obtener el clima: ${response.body}");
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return null;
    }
  }
}
