import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openweather/model/datamodel.dart';
import 'package:openweather/model/service.dart';

class AppColors {
  static const contentColorCyan = Color(0xff000000);
  static const contentColorBlue = Color(0xff000000);
  static const mainGridLineColor = Color(0xff000000);
}

class ChartForecast extends StatefulWidget {
  const ChartForecast({Key? key}) : super(key: key);

  @override
  State<ChartForecast> createState() => _ChartForecastState();
}

class _ChartForecastState extends State<ChartForecast> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    Colors.transparent,
  ];

  bool showAvg = false;
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    // Replace with your latitude and longitude
    double lat = 37.7749; // Example latitude
    double lon = -122.4194; // Example longitude

    return Container(
      padding: EdgeInsets.all(11),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xffD0BCFF).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FutureBuilder<List<Forecast>>(
        future: apiService.fetchForecast(lat, lon),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No forecast data available'));
          } else {
            final forecasts = snapshot.data!;
            // Normalize temperature values between -10 and 10
            double minTemp =
                forecasts.map((f) => f.temp).reduce((a, b) => a < b ? a : b);
            double maxTemp =
                forecasts.map((f) => f.temp).reduce((a, b) => a > b ? a : b);

            List<FlSpot> forecastSpots =
                forecasts.take(7).toList().asMap().entries.map((e) {
              double normalizedTemp =
                  _normalizeTemperature(e.value.temp, minTemp, maxTemp);
              return FlSpot(e.key.toDouble(), normalizedTemp);
            }).toList();

            return Column(
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Day forecast'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                AspectRatio(
                  aspectRatio: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LineChart(
                      showAvg
                          ? avgData(forecastSpots)
                          : mainData(forecastSpots),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  double _normalizeTemperature(double temp, double minTemp, double maxTemp) {
    // Normalize the temperature to be between -10 and 10
    return ((temp - minTemp) / (maxTemp - minTemp)) * 20 - 10;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 16,
    );
    String text;
    switch (value.toInt()) {
      case -10:
        text = '-10';
        break;
      case 0:
        text = '0';
        break;
      case 10:
        text = '10';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<FlSpot> forecastSpots) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: 8,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black12,
            strokeWidth: 2,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 0,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 6,
      minY: -10,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: forecastSpots,
          isCurved: true,
          color: Color(0xff21005D), // Change line color to black
          barWidth: 3.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Color(0xff21005D)
                    .withOpacity(0.2), // Top color black with some opacity
                Colors.transparent, // Bottom color transparent
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData(List<FlSpot> forecastSpots) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: forecastSpots,
          isCurved: true,
          color: Colors.amber,
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.black,
          ),
        ),
      ],
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 6,
      minY: -10,
      maxY: 10,
    );
  }
}
