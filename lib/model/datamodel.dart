class Weather {
  final String name;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final int sunrise;
  final int sunset;

  Weather({
    required this.name,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      name: json['name'],
      country: json['sys']['country'],
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      visibility: json['visibility'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDeg: json['wind']['deg'],
      weatherMain: json['weather'][0]['main'],
      weatherDescription: json['weather'][0]['description'],
      weatherIcon: json['weather'][0]['icon'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}




class Forecast {
  final int dt;
  final double temp;
  final String description;
  final String icon;

  Forecast({
    required this.dt,
    required this.temp,
    required this.description,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dt: json['dt'],
      temp: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      
    );
  }
}
