import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:math';
import 'package:group_project/providers/tv_show_provider.dart';
import '../models/tv_show_model.dart';
import '../screens/main_screeen.dart';
import '../screens/tv_show_details.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  late GlobalKey<NavigatorState> navigatorKey;

  Future<void> initialize(GlobalKey<NavigatorState> key) async {
    navigatorKey = key;

    var androidInitializationSettings = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          print("Opening show with ID: ${response.payload}");
          int? showId = int.tryParse(response.payload!);

          if (showId != null && showId > 0) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => ShowDetailsScreen(showId: showId),
              ),
            );
          } else {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        } else {
          print("No valid payload, opening Home Screen.");
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      },
    );

    await scheduleDailyRecommendation();
    await scheduleRandomNotification();
  }

  Future<void> scheduleDailyRecommendation() async {
    final now = DateTime.now();
    final targetTime = DateTime(now.year, now.month, now.day, 16, 30, 0);
    final duration = targetTime.isBefore(now)
        ? targetTime.add(Duration(days: 1)).difference(now)
        : targetTime.difference(now);

    print("Current time: ${now.toString()}");
    print("Scheduled time: ${targetTime.toString()}");
    print("Time difference (duration): ${duration.inSeconds} seconds");

    Timer(duration, () {
      print('Timer expired at: ${DateTime.now().toString()}');

      flutterLocalNotificationsPlugin.show(
        0,
        'Daily Recommendation',
        'Get your daily TV show recommendation!',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Recommendations',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: '',
      );

      print('Notification sent at: ${DateTime.now().toString()}');

      scheduleDailyRecommendation();
    });
  }

  Future<void> showNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'general_channel_id',
          'General Notifications',
          importance: Importance.high,
        ),
      ),
    );
  }


  Future<void> scheduleRandomNotification() async {
    final now = DateTime.now();
    final random = Random();
    int randomHour = random.nextInt(24);
    int randomMinute = random.nextInt(60);

    final randomTime = DateTime(now.year, now.month, now.day, randomHour, randomMinute, 0);
    final duration = randomTime.isBefore(now)
        ? randomTime.add(Duration(days: 1)).difference(now)
        : randomTime.difference(now);

    print('Scheduling random notification at: ${randomTime.toString()}');
    print('Time until notification: ${duration.inSeconds} seconds');

    Timer(duration, () async {
      print('Timer expired for random notification at: ${DateTime.now().toString()}');

      ShowDetails? randomShow = await getRandomTVShow();

      if (randomShow == null) {
        print('No random show available.');
        return;
      }

      print('Random show selected: ${randomShow.name} with ID: ${randomShow.id}');

      flutterLocalNotificationsPlugin.show(
        1,
        'Daily Recommendation',
        "Today's TV Show recommendation: ${randomShow.name}",
        NotificationDetails(
          android: AndroidNotificationDetails(
            'random_channel_id',
            'Random Recommendations',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: randomShow.id.toString(),
      );

      print('Random notification sent at: ${DateTime.now().toString()}');

      scheduleRandomNotification();
    });
  }

  Future<ShowDetails?> getRandomTVShow() async {
    print('Fetching random TV show...');

    TVShowProvider tvShowProvider = TVShowProvider();
    List<ShowDetails> shows = await tvShowProvider.fetchRandomTVShow();

    if (shows.isEmpty) {
      print('No shows available.');
      return null;
    }

    final random = Random();
    ShowDetails randomShow = shows[random.nextInt(shows.length)];

    print('Random show selected: ${randomShow.name} with ID: ${randomShow.id}');
    return randomShow;
  }
}
