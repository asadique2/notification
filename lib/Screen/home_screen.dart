import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification/Screen/second_screen.dart';
import 'package:notification/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String navigateTo;
  @override
  void initState() {
    LocalNotificationService.initialize();

    listenNotification();

    getDeviceTokenToSendNotification();

    /// This method call when app in terminated state
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          LocalNotificationService.displayNotification(message);
          navigateTo = message.notification?.title ?? '-';
          onClickedNotification(message.notification?.title);
        }
      },
    );

    /// 2. This method only call when App in foreground
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          navigateTo = message.notification?.title ?? '_';
          LocalNotificationService.displayNotification(message);
        }
      },
    );

    /// This method only call when App in background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          onClickedNotification(message.notification?.title);
        }
      },
    );
    super.initState();
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    print("Token Value : $token");
  }

  void listenNotification() {
    LocalNotificationService.onNotification.stream
        .listen(onClickedNotification);
  }

  onClickedNotification(data) {
    if (data == 'page1' || navigateTo == 'page1') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SecondScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Home page'),
      ),
    );
  }
}
