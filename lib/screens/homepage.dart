import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:openweather/model/service.dart';
import 'package:openweather/model/datamodel.dart';
import 'package:openweather/widget/chartforecast.dart';
import 'package:openweather/widget/currentweather.dart';
import 'package:openweather/widget/headertext.dart';
import 'package:openweather/widget/hourlyforecast.dart';
import 'package:openweather/widget/rainprecipitation.dart'; // Replace with actual import paths

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Weather>? weatherData;
  Future<List<Forecast>>? forecastData;
  final ApiService apiService = ApiService();
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final permissionStatus = await Geolocator.checkPermission();

    if (permissionStatus == LocationPermission.denied) {
      final requestStatus = await Geolocator.requestPermission();

      if (requestStatus != LocationPermission.whileInUse &&
          requestStatus != LocationPermission.always) {
        print("Location permissions are denied.");
        // Handle the case where permissions are denied
        // You can show a message to the user and/or navigate to settings
        return;
      }
    } else if (permissionStatus == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      // Handle the case where permissions are permanently denied
      // You can show a message to the user and/or navigate to settings
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      fetchDataForLocation(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
      // Handle the error or show a message to the user
    }
  }

  Future<void> _handlePermissionDenied() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Denied'),
        content: Text('Please grant location permission to use this feature.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Optionally open settings
              Geolocator.openAppSettings();
            },
            child: Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }



  void fetchDataForLocation(double lat, double lon) {
    setState(() {
      weatherData = apiService.fetchWeather(lat, lon);
      forecastData = apiService.fetchForecast(lat, lon);
    });
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM d, HH:mm');
    return formatter.format(dateTime);
  }

  String formatTime(DateTime time) {
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(time);
  }

  final currentTime = DateTime.now();

  void searchCityWeather(String cityName) async {
    try {
      final locationData = await apiService.searchWeather(cityName);
      final double? lat = locationData['lat'];
      final double? lon = locationData['lon'];

      if (lat != null && lon != null) {
        fetchDataForLocation(lat, lon);
      } else {
        // Handle the case where latitude or longitude is null
        print("Latitude or Longitude is null.");
        // Optionally show an error message to the user
      }
    } catch (e) {
      print("Error searching weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CupertinoActivityIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (!snapshot.hasData) {
          return Scaffold(
              body: Center(child: Text('No weather data available')));
        } else {
          final weather = snapshot.data!;

          var sunset =
              DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000);
          var sunrise =
              DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000);

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: isSearching
                  ? TextField(
                      controller: searchController,
                      autofocus: true,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter city name',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        searchCityWeather(value);
                        setState(() {
                          isSearching = false;
                        });
                      },
                    )
                  : Text(
                      '${weather.name}, ${weather.country}',
                      style: TextStyle(color: Colors.white),
                    ),
              actions: [
                IconButton(
                  icon: Icon(isSearching ? Icons.close : Icons.search,
                      color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (isSearching) {
                        isSearching = false;
                        searchController.clear();
                      } else {
                        isSearching = true;
                      }
                    });
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(33),
                            bottomRight: Radius.circular(33)),
                        child: Image.asset('assets/images/cover.jpg'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 80),
                                    HeaderText(
                                      text:
                                          '${weather.temperature.toStringAsFixed(0)}°',
                                      size: 85,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 120),
                                    HeaderText(
                                      text:
                                          'Feels like ${weather.feelsLike.toStringAsFixed(0)}°',
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network(
                                      'https://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
                                    ),
                                    Positioned(
                                      top: 80,
                                      child: Container(
                                        width: 100,
                                        child: Text(
                                          weather.weatherDescription,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              height: 1,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 80),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: HeaderText(
                                    text: formatDateTime(currentTime)))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CurrentWeather(
                              title: 'Wind speed',
                              weather: '${weather.windSpeed}Km/h',
                              weatherType: WeatherType.wind,
                            ),
                            CurrentWeather(
                              title: 'Rain chance',
                              weather: '${weather.windSpeed}',
                              weatherType: WeatherType.rain,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CurrentWeather(
                              title: 'Pressure',
                              weather: '${weather.pressure} hpa',
                              weatherType: WeatherType.pressure,
                            ),
                            CurrentWeather(
                              title: 'UV Index',
                              weather: '${weather.windSpeed}',
                              weatherType: WeatherType.uvindex,
                            ),
                          ],
                        ),
                        FutureBuilder<List<Forecast>>(
                          future: forecastData,
                          builder: (context, forecastSnapshot) {
                            if (forecastSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CupertinoActivityIndicator());
                            } else if (forecastSnapshot.hasError) {
                              return Center(
                                  child:
                                      Text('Error: ${forecastSnapshot.error}'));
                            } else if (!forecastSnapshot.hasData) {
                              return Center(
                                  child: Text('No forecast data available'));
                            } else {
                              return Column(
                                children: [
                                  HourlyForecast(
                                      forecasts: forecastSnapshot.data!),
                                  ChartForecast(),
                                  RainPrecipitation(),
                                ],
                              );
                            }
                          },
                        ),
                        Row(
                          children: [
                            CurrentWeather(
                              title: 'Sunrise',
                              weather: '${formatTime(sunrise)}',
                              weatherType: WeatherType.sunrise,
                            ),
                            CurrentWeather(
                              title: 'Sunset',
                              weather: '${formatTime(sunset)}',
                              weatherType: WeatherType.sunset,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

}
