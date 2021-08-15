import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:notifications_two/notifications_provider.dart';
import 'package:notifications_two/prayer_model.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Prayer> prayers = getPrayers();
    var notifications =
        Provider.of<NotificationsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Notifications Testing",
          style: style(),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prayers.length,
                  itemBuilder: (context, index) {
                    Prayer pr = prayers[index];
                    List<bool> list = notifications.getNotifications();
                    return Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(pr.name, style: style())),
                          Expanded(
                            child: Text(
                                pr.hour.toString() + ":" + pr.minute.toString(),
                                style: style()),
                          ),
                          // Text("Hello", style: style()),
                          FlutterSwitch(
                            activeColor: Colors.green,
                            inactiveColor: Colors.white,
                            inactiveTextColor: Colors.black,
                            activeTextColor: Colors.white,
                            width: 70.0,
                            height: 30.0,
                            valueFontSize: 15.0,
                            toggleSize: 15.0,
                            value: list[index],
                            padding: 8.0,
                            showOnOff: true,
                            onToggle: (value) {
                              setState(() {
                                notifications.updateNotifications(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Prayer nextPrayer = getNextPrayer();
                  scheduleAlarm(10, "Salat Al ${nextPrayer.name} 🤲",
                      "It's time of prayer now : ${nextPrayer.hour}:${nextPrayer.minute} 🕌");
                },
                child: Text(
                  "Get Notified After 10 Seconds",
                  style: style(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle style() {
  return const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

void scheduleAlarm(int seconds, String title, String body) async {
  var scheduledNotificationDateTime =
      DateTime.now().add(Duration(seconds: seconds));
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: 'solidarieta_logo',
    sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    largeIcon: DrawableResourceAndroidBitmap('solidarieta_logo'),
  );

  var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  // ignore: deprecated_member_use
  await flutterLocalNotificationsPlugin.schedule(
    0,
    title,
    body,
    scheduledNotificationDateTime,
    platformChannelSpecifics,
  );
}
