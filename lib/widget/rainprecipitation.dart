import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openweather/model/raindata.dart';

class RainPrecipitation extends StatelessWidget {
  const RainPrecipitation({super.key});

  String formatTime(DateTime dateTime) {
    // Use the DateFormat class from the intl package to format the time
    final hours = dateTime.hour;
    final period = hours >= 12 ? 'PM' : 'AM';
    final formattedHour = hours % 12 == 0 ? 12 : hours % 12;

    return '$formattedHour $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xffD0BCFF).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child: Icon(
                  Icons.cloud_outlined,
                  size: 16,
                ),
              ),
              SizedBox(width: 10),
              Text('Chance of rain'),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              final time = formatTime(raindata[index]['time']);

              final rainPercentage = raindata[index]['precipitation'] * 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 50,
                        child: Text(
                          time,
                          style: TextStyle(fontSize: 15),
                        )),
                    SizedBox(
                        width:
                            10), // Add some space between the text and the progress indicator
                    Expanded(
                      child: LinearProgressIndicator(
                        color: Color(0xff8A20D5),
                        minHeight: 24,
                        borderRadius: BorderRadius.circular(100),
                        backgroundColor: Color(0xffFAEDFF),
                        value: raindata[index]['precipitation'],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                        width: 35,
                        child: Text(
                          '${rainPercentage.toStringAsFixed(0)} %',
                          style: TextStyle(fontSize: 15),
                        )),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
