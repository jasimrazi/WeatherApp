import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openweather/model/datamodel.dart';
import 'package:openweather/utils/apikey.dart';

class ApiService {
  final String url = 'https://api.openweathermap.org/data/';

  Future<Weather> fetchWeather(double lat, double lon) async {
    try {
      final endpoint =
          '${url}2.5/weather?lat=$lat&lon=$lon&appid=$apikey&units=metric';

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else {
        final Map<String, dynamic> error = jsonDecode(response.body);
        throw Exception('Error fetching weather data: ${error['message']}');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<List<Forecast>> fetchForecast(double lat, double lon) async {
    try {
      final endpoint =
          '${url}2.5/forecast?lat=$lat&lon=$lon&appid=$apikey&units=metric';

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> forecastList = data['list'];
        return forecastList.map((json) => Forecast.fromJson(json)).toList();
      } else {
        final Map<String, dynamic> error = jsonDecode(response.body);
        throw Exception('Error fetching forecast data: ${error['message']}');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<Map<String, double>> searchWeather(String cityName) async {
    try {
      final endpoint =
          '${url}2.5/weather?q=$cityName&appid=$apikey&units=metric';

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final lat = data['coord']['lat'];
        final lon = data['coord']['lon'];
        return {'lat': lat, 'lon': lon};
      } else {
        final Map<String, dynamic> error = jsonDecode(response.body);
        throw Exception('Error fetching weather data: ${error['message']}');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
