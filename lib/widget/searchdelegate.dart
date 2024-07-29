// import 'package:flutter/material.dart';
// import 'package:openweather/model/service.dart';
// import 'package:openweather/model/datamodel.dart';

// class WeatherSearchDelegate extends SearchDelegate<Weather?> {
//   final ApiService apiService;

//   WeatherSearchDelegate(this.apiService);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     if (query.isEmpty) {
//       return Center(child: Text('Please enter a city name.'));
//     }

//     return FutureBuilder<Weather>(
//       future: apiService.searchWeather(query),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData) {
//           return Center(child: Text('No weather data available'));
//         } else {
//           final weather = snapshot.data!;
//           return ListTile(
//             title: Text('${weather.name}, ${weather.country}'),
//             subtitle: Text('Temperature: ${weather.temperature}°C'),
//             onTap: () {
//               close(context, weather);
//             },
//           );
//         }
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Center(child: Text('Enter the city name.'));
//   }
// }
