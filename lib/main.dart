// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/controller/guest_controller.dart';
import 'package:cabme/controller/settings_controller.dart';
import 'package:cabme/firebase_options.dart';
import 'package:cabme/model/ride_model.dart';
import 'package:cabme/page/localization_screens/localization_screen.dart';
import 'package:cabme/page/route_view_screen/route_osm_view_screen.dart';
import 'package:cabme/page/route_view_screen/route_view_screen.dart';
import 'package:cabme/themes/styles.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'page/auth_screens/login_screen.dart';
import 'page/chats_screen/conversation_screen.dart';
import 'page/completed_ride_screens/trip_history_screen.dart';
import 'page/dash_board.dart';
import 'page/on_boarding_screen.dart';
import 'service/localization_service.dart';
import 'utils/Preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Preferences.initPref();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (!Platform.isIOS) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt > 28) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getCurrentAppTheme();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    initialize(context);
    await FirebaseMessaging.instance.subscribeToTopic("cabme_customer");
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {}

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        display(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        if (message.data['status'] == "done") {
          await Get.to(ConversationScreen(), arguments: {
            'receiverId': int.parse(
                json.decode(message.data['message'])['senderId'].toString()),
            'orderId': int.parse(
                json.decode(message.data['message'])['orderId'].toString()),
            'receiverName':
                json.decode(message.data['message'])['senderName'].toString(),
            'receiverPhoto':
                json.decode(message.data['message'])['senderPhoto'].toString(),
          });
        } else if (message.data['statut'] == "confirmed" ||
            message.data['statut'] == "driver_rejected") {
          DashBoardController dashBoardController =
              Get.put(DashBoardController());
          dashBoardController.selectedDrawerIndex.value = 1;
          await Get.to(DashBoard());
        } else if (message.data['statut'] == "on ride") {
          var argumentData = {
            'type': 'on_ride'.tr,
            'data': RideData.fromJson(message.data)
          };

          if (Constant.selectedMapType == 'osm') {
            Get.to(const RouteOsmViewScreen(), arguments: argumentData);
          } else {
            Get.to(const RouteViewScreen(), arguments: argumentData);
          }
        } else if (message.data['statut'] == "completed") {
          Get.to(TripHistoryScreen(), arguments: {
            "rideData": RideData.fromJson(message.data),
          });
        }
      }
    });
  }

  Future<void> initialize(BuildContext context) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: iosInitializationSettings);
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {});

    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "01",
        "cabme",
        importance: Importance.max,
        priority: Priority.high,
      ));

      await FlutterLocalNotificationsPlugin().show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Register GuestController
    Get.put(GuestController(), tag: 'guest');

    setupInteractedMessage(context);
    Future.delayed(const Duration(seconds: 3), () {
      if (Preferences.getString(Preferences.languageCodeKey)
          .toString()
          .isNotEmpty) {
        LocalizationService().changeLocale(
            Preferences.getString(Preferences.languageCodeKey).toString());
      }
    });
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(builder: (context, value, child) {
      return GetMaterialApp(
        title: 'Flex',
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData(
            themeChangeProvider.darkTheme == 0
                ? true
                : themeChangeProvider.darkTheme == 1
                    ? false
                    : themeChangeProvider.getSystemThem(),
            context),
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.locale,
        translations: LocalizationService(),
        builder: EasyLoading.init(),
        home: GetBuilder(
            init: SettingsController(),
            builder: (controller) {

              if (Preferences.getString(Preferences.languageCodeKey)
                  .toString()
                  .isEmpty) {
                return const LocalizationScreens(intentType: "main");
              } else if (!Preferences.getBoolean(
                  Preferences.isFinishOnBoardingKey)) {
                return const OnBoardingScreen();
              } else if (Preferences.getBoolean(Preferences.isGuestUser)) {
                return DashBoard();
              } else if (Preferences.getBoolean(Preferences.isLogin)) {
                return DashBoard();
              } else {
                return const LoginScreen();
              }
            }),
      );
    }),
    );
  }
}
