import 'dart:ffi';

import 'package:flutter/material.dart';

enum WeatherType {
  wind,
  rain,
  pressure,
  uvindex,
  sunrise,
  sunset,
}

class CurrentWeather extends StatelessWidget {
  final String title;
  final String weather;
  final WeatherType weatherType;

  const CurrentWeather(
      {super.key,
      required this.title,
      required this.weather,
      required this.weatherType});

  IconData _getIconForType(WeatherType type) {
    switch (type) {
      case WeatherType.wind:
        return Icons.air;
      case WeatherType.rain:
        return Icons.cloud_outlined;
      case WeatherType.pressure:
        return Icons.waves;
      case WeatherType.uvindex:
        return Icons.wb_sunny_outlined;
      case WeatherType.sunrise:
        return Icons.wb_twilight;
      case WeatherType.sunset:
        return Icons.nights_stay;
      default:
        return Icons.help; // Default icon if none of the types match
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.all(11),
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
              color: Color(0xffD0BCFF).withOpacity(0.3),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(
                    _getIconForType(weatherType),
                    size: 16,
                  )),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    weather,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
