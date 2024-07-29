import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openweather/model/datamodel.dart';

class HourlyForecast extends StatelessWidget {
  final List<Forecast> forecasts; // Update this line

  const HourlyForecast(
      {super.key, required this.forecasts}); // Update this line

  String formatTime(DateTime time) {
    final DateFormat formatter = DateFormat('h:a');
    return formatter.format(time).replaceAll(':', '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(11),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xffD0BCFF).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: Icon(
                      Icons.history_toggle_off,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('Hourly forecast'),
                ],
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 110,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: forecasts.length,
                  itemBuilder: (context, index) {
                    final forecast = forecasts[index];

                    var time =
                        DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000);

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        double itemWidth = 80;
                        double itemHeight = 110;

                        return Container(
                          width: itemWidth,
                          constraints: BoxConstraints(
                            minWidth: 0,
                            maxWidth: constraints.maxWidth / forecasts.length,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatTime(time),
                                style: TextStyle(fontSize: 14),
                              ),
                              Image.network(
                                'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
                                width: itemWidth,
                                height: itemHeight / 2,
                              ),
                              Text(
                                '${forecast.temp.toStringAsFixed(0)}°',
                                style: TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

