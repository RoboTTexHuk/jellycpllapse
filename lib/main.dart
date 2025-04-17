import 'dart:convert';

import 'package:app_tracking_transparency/app_tracking_transparency.dart' show AppTrackingTransparency, TrackingStatus;
import 'package:appsflyer_sdk/appsflyer_sdk.dart' show AppsFlyerOptions, AppsflyerSdk;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodCall, MethodChannel;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:jellycollapse/pushweb.dart' show pusWeb;
import 'package:jellycollapse/tokenhandler.dart' show getFcmToken;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;
import 'package:url_launcher/url_launcher_string.dart';


import 'package:http/http.dart' as http;

import 'LoadLoader.dart' show FILT;






@pragma('vm:entry-point') // Ensure the function is preserved for native usage
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Print the message body
  print("Handling a background message: ${message.messageId}");
  print("Message Data: ${message.data}");

  // Use this function to forward data to the app UI through notification
  _handleBackgroundMessage(message);
  _handleIncomingMessage(message);
}

final MethodChannel platform = MethodChannel('com.example.fcm/notification');

void listenToNativeMessages(BuildContext context) {
  platform.setMethodCallHandler((call) async {
    if (call.method == "onMessage") {
      final Map<String, dynamic> data = Map<String, dynamic>.from(call.arguments);
      print("Получено уведомление из iOS во ФЛуттур: $data");

      // Переход на экран уведомлений
      //    Navigator.pushNamed(context, '/notification', arguments: data['aps']['alert']['body']);
    }
  });
}

String listenToNotificationTaps(BuildContext context) {
  String uri="";
  platform.setMethodCallHandler((call) async {
    if (call.method == "onNotificationTap") {
      final Map<String, dynamic> data = Map<String, dynamic>.from(call.arguments);
      print("Данные уведомления из iOS: $data");

      // Получение title и body
      String? title = data['title'];
      String? body = data['body'];
      uri = data['uri'];

      print("URI: $uri");

    }
  });

  return uri;
}

// Global function to handle incoming messages
void _handleIncomingMessage(RemoteMessage message) {
  final messageData = {
    "title": message.notification?.title ?? "No Title",
    "body": message.notification?.body ?? "No Body",
    "data": message.data,
  };

  // Update the ValueNotifier with the new message
  // MyApp.globalNotifier.value = messageData;
}

// Global function to handle background message
void _handleBackgroundMessage(RemoteMessage message) {
  // Use a global key to access the current context
  final body = jsonEncode(message.data); // Convert message data to JSON string
  print("Forwarding message to UI: $body");

  // Notify any listener about the message
  // MyApp.globalNotifier.value = body;
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Включение отладки для WebView на Android
  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // Инициализация временной зоны
  tz.initializeTimeZones();
  // Register the background message handler



  runApp( MaterialApp(home: getFcmToken()));
}



class WebViewScreen extends StatefulWidget {
  String? tokenload="";
  WebViewScreen(this.tokenload);

  @override
  _WebViewScreenState createState() => _WebViewScreenState(tokenload);
}

class _WebViewScreenState extends State<WebViewScreen> {
  _WebViewScreenState(this.tokenload);
  late InAppWebViewController webViewController;
  String? tokenload;
  String? fcmToken;
  String? deviceId;
  String? instanceId;
  String? platform;
  String? osVersion;
  String? appVersion;
  String? language;
  String? timezone;
  bool pushEnabled = true;
  int _totalNotifications=0;
  // PushNotification? _notificationInfo;
  bool _isLoading = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _title; // Заголовок уведомления
  String? _body; // Текст уведомления
  String? _url; // URL для перехода
  String? _imageUrl; // URL изображения из уведомления

  String? _notificationTitle;
  String? _notificationBody;
  Map<String, dynamic>? _notificationData;
  String _finalUrl="https://n1cdata-lobster-app-pvvg3.ondigitalocean.app/";

  String? _messageTitle;
  String? _messageBody;

  String? _notificationUri;
  String token = "";
  String FlyerId = "";
  String? advertisingId = "";
  String af_status = "";
  String af_message = " ";
  String install_time = "";
  String campaign = "";
  String campaign_id = "";
  double height = 0;
  double weight = 0;
  String is_first_launch = "";
  Map resLoad = Map();
  late AppsflyerSdk _appsflyerSdk;
  String fbc = "";
  String fbp = "";

  String? deep_link_value = "";
  String ConVData = "";
  String Toke = "087e0aa4-4926-4f76-9b21-d93311646570";
  String Bund = 'com.jetbet.jetbet.jetbet';
  String appsDevID = "qsBLmy7dAXDQhowM8V3ca4";

  String?  deep="";
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Print the message body
    print("Handling a background messageVVVVV: ${message.messageId}");
    print("Message DataVVVV: ${message.data}");

    // Use this function to forward data to the app UI through notification
    _handleBackgroundMessage(message);
    _handleIncomingMessage(message);
  }
// Global function to handle incoming messages
  void _handleIncomingMessage(RemoteMessage message) {
    final messageData = {
      "title": message.notification?.title ?? "No Title",
      "body": message.notification?.body ?? "No Body",
      "data": message.data,
    };
    final body = jsonEncode(message.data); // Convert message data to JSON string
    _showMessageDialog(body);
    // Update the ValueNotifier with the new message
    //  MyApp.globalNotifier.value = messageData;
  }

// Global function to handle background message
  void _handleBackgroundMessage(RemoteMessage message) {
    // Use a global key to access the current context
    final body = jsonEncode(message.data); // Convert message data to JSON string
    print("Forwarding message to UI: $body");
    _showMessageDialog(body);
    // Notify any listener about the message
    // MyApp.globalNotifier.value = body;
  }
  void _showMessageDialog(String messageBody) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Background Notification"),
        content: SingleChildScrollView(
          child: Text(
            messageBody,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void SetUrl(String uri) async {

    print("my uri here "+_finalUrl+uri.toString());
    if (webViewController != null) {
      await webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri(uri)),
      );
    }

  }
  setemptyUrl() async {
    new Future.delayed(const Duration(seconds: 3), () {
      if (webViewController != null) {
        webViewController.loadUrl(
          urlRequest: URLRequest(url: WebUri(_finalUrl)),
        );
      }
    });

  }

  Future<String> handleMessageBackground(RemoteMessage message) async {


    print("My mesage "+message.data.toString());
    return "YES" ;
  }
  void _showMessage(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
  var contentBlockerEnabled = true;
  final List<ContentBlocker> contentBlockers = [];
  @override
  void initState() {
    super.initState();


    for (final adUrlFilter in FILT) {
      contentBlockers.add(ContentBlocker(
          trigger: ContentBlockerTrigger(
            urlFilter: adUrlFilter,
          ),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          )));
    }

    contentBlockers.add(ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: ".cookie", resourceType: [
        //   ContentBlockerTriggerResourceType.IMAGE,

        ContentBlockerTriggerResourceType.RAW
      ]),
      action: ContentBlockerAction(
          type: ContentBlockerActionType.BLOCK, selector: ".notification"),
    ));

    contentBlockers.add(ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: ".cookie", resourceType: [
        //   ContentBlockerTriggerResourceType.IMAGE,

        ContentBlockerTriggerResourceType.RAW
      ]),
      action: ContentBlockerAction(
          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
          selector: ".privacy-info"),
    ));
    // apply the "display: none" style to some HTML elements
    contentBlockers.add(ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(
            type: ContentBlockerActionType.CSS_DISPLAY_NONE,
            selector: ".banner, .banners, .ads, .ad, .advert")));



    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // listenToNativeMessages(context);
    // Обработка данных уведомлений
    _initializeATT();
    InitFlyer();
    _notificationChannel.setMethodCallHandler((call) async {
      if (call.method == "onNotificationTap") {
        final Map<String, dynamic> notificationData =
        Map<String, dynamic>.from(call.arguments);
        print("Получены данные из уведомления: $notificationData");

        // Извлекаем URI
        if (notificationData["uri"] != null) {
          String uri = notificationData["uri"];
          print("Получен URI: $uri");

          // Загружаем страницу с URI в WebView
          if (webViewController != null) {
            webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(uri)));
          }
        }
      }
    });
    const MethodChannel _platform =
    MethodChannel('com.example.app');


    print(" LOADE "+tokenload.toString());
    // Слушатель для сообщений в background
    // Слушатель для сообщений в background
    BackgroundMessageHandler.listenForBackgroundMessages((title, body, uri) {


      _showMessage(context, "данные из бэкграунд пуша "+title.toString(),body.toString());
      setState(() {
        _notificationTitle = title;
        _notificationBody = body;
        _notificationUri = uri;
        deep=uri;
      });
      loadToServerOleg();
      print("Сообщение получено в background:");
      print("Title: $title");
      print("Body: $body");
      print("URI: $uri");

      if (uri != null) {
        print("Загрузка URI в WebView: $uri");

        SetUrl(uri);
        // webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(uri)));
      }
      else{
        setemptyUrl();
      }
    });


    // Подключение слушателя для обработки нажатий на уведомления
    NotificationTapListener.listenForNotificationTaps((uri, title, body) {
      setState(() {
        _notificationUri = uri;
        _notificationTitle = title;
        _notificationBody = body;
        deep=uri;
      });
      loadToServerOleg();
      // Логика обработки URI, например, передача в WebView
      if (uri != null) {
        print("Загрузка URI в WebView: $uri");

        SetUrl(uri);
        // webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(uri)));
      }
      else{
        setemptyUrl();
      }
    });

    // Listen for foreground messages
    // Request notification permissions (iOS specific)
    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a foreground message: ${message.messageId}");
      setState(() {
        _notificationTitle = message.notification?.title ?? "No Title";
        _notificationBody = message.notification?.body ?? "No Body";
        _notificationData = message.data;
      });

      if(message.data['uri']!=null){

        SetUrl(message.data['uri'].toString());
      }
      else {
        setemptyUrl();
      }
      print("Body IMAGE"+message.notification!.body.toString());
    });

    // Handle messages when the app is opened from a terminated state
    _checkInitialMessage();

    _initializeData();
    _initializeFirebaseMessaging();
    // Listen to the global notifier for new messages
    /*  MyApp.globalNotifier.addListener(() {
      final message = MyApp.globalNotifier.value;
      if (message != null) {
  //      _showMessageDialog3(message);
      }
    });*/
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      if(message.data['uri']!=null){

        SetUrl(message.data['uri'].toString());
      }
      else {
        setemptyUrl();
      }
      print("Body IMAGE"+message.notification!.body.toString());
      //    _showTopNotification(context, message);
    });


    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      _showMessage(context, "данные из бэкграунд пуша "+message.notification!.title.toString(),message.notification!.body.toString());
      final messageData = {
        "title": message.notification?.title ?? "No Title",
        "body": message.notification?.body ?? "No Body",
        "data": message.data,
      };

      print("Body IMAGE"+message.notification!.body.toString());
      final imageUrl = message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl;
      _showTopNotification(context, message,  imageUrl);

      // Trigger the dialog
      //  _showMessageDialog3(messageData);
    });



    Future.delayed(const Duration(seconds: 6), () {
      //   getRemote();
      //   getApp();
      //  geTr();
      loadToServerOleg();
    });
  }

  // Метод для проверки, пришло ли сообщение при запуске приложения
  Future<void> _checkInitialMessage() async {
    final RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // Если есть сообщение, обработайте его



      _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          print("App launched with a message: ${message.data.toString()}");
          setState(() {
            _notificationTitle = message.notification?.title ?? "No Title";
            _notificationBody = message.notification?.body ?? "No Body";
            _notificationData = message.data;
          });


          if(message.data['uri']!=null){

            SetUrl(message.data['uri'].toString());
          }
          else {
            setemptyUrl();
          }
          //  _showDeep(message.data.toString());
        }
      });
      setState(() {
        _messageTitle = initialMessage.notification?.title ?? "No Title";
        _messageBody = initialMessage.notification?.body ?? "No Body";
      });
      debugPrint("Message received on app launch: ${initialMessage.messageId}");
    } else {
      // Если сообщения нет

      setemptyUrl();
      debugPrint("No message received on app launch.");
      setState(() {
        _messageTitle = "No message";
        _messageBody = "No data received at app launch.";
      });
    }
  }



  Future<void> _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Запрос разрешения на получение уведомлений
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint(
        'Статус разрешения на уведомления: ${settings.authorizationStatus}');

    // Получение FCM токена
    fcmToken = await messaging.getToken();
    debugPrint("FCM Token: $fcmToken");
  }

  // Обработка уведомлений, когда приложение свернуто


  // Метод для открытия URL





  Future<void> _initializeData() async {
    try {
      // Получение информации об устройстве
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        platform = "android";
        osVersion = androidInfo.version.release;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
        platform = "ios";
        osVersion = iosInfo.systemVersion;
      }

      // Получение версии приложения
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;

      // Получение языка устройства
      language = Platform.localeName.split('_')[0];

      // Получение временной зоны
      timezone = tz.local.name;

      // Генерация instance_id (пример с UUID)
      instanceId = "d67f89a0-1234-5678-9abc-def012345678";

      // После получения всех данных передаем их в WebView
      if (webViewController != null) {
        _sendDataToWebView();
      }
    } catch (e) {
      debugPrint("Ошибка при инициализации данных: $e");
    }
  }
  void loadToServerOlegTWO() async {
    print("CONV DATA"+ConVData.toString());
    final jsonData = {
      "content": {
        "af_data": "${ConVData}",
        "af_id": "${FlyerId}",
        "fb_app_name": "Jet4Bet",
        "app_name": "Jet4Betv1",
        "deep":deep,
        "bundle_identifier": "com.jetbet.jetbet.jetbet",
        "app_version": "1.0.0",
        "apple_id": "6744022823",
        "fcm_token": tokenload ?? "default_fcm_token",
        "device_id": deviceId ?? "default_device_id",
        "instance_id": instanceId ?? "default_instance_id",
        "platform": platform ?? "unknown_platform",
        "os_version": osVersion ?? "default_os_version",
        "app_version": appVersion ?? "default_app_version",
        "language": language ?? "en",
        "timezone": timezone ?? "UTC",
        "push_enabled": pushEnabled,
        "useruid": "${FlyerId}",
      },
    };



    // Отправка данных на сервер
    await sendDataToServer(jsonData);

    // Конвертируем в строку
    final jsonString = jsonEncode(jsonData);

    await webViewController!.evaluateJavascript(
      source: "sendRawData(${jsonEncode(jsonString)});",
    );
  }
  void loadToServerOleg() async {
    print("CONV DATA"+ConVData.toString());
    final jsonData = {
      "content": {
        "af_data": "${ConVData}",
        "af_id": "${FlyerId}",
        "fb_app_name": "Jellycollapse",
        "app_name": "Jellycollapse",
        "deep":deep,
        "bundle_identifier": "jellycollapse.jellycollapse.jellycollapse.jellycollapse",
        "app_version": "1.0.0",
        "apple_id": "6744022823",
        "fcm_token": tokenload ?? "default_fcm_token",
        "device_id": deviceId ?? "default_device_id",
        "instance_id": instanceId ?? "default_instance_id",
        "platform": platform ?? "unknown_platform",
        "os_version": osVersion ?? "default_os_version",
        "app_version": appVersion ?? "default_app_version",
        "language": language ?? "en",
        "timezone": timezone ?? "UTC",
        "push_enabled": pushEnabled,
        "useruid": "${FlyerId}",
      },
    };



    // Отправка данных на сервер
    await sendDataToServer(jsonData);

    // Конвертируем в строку
    final jsonString = jsonEncode(jsonData);

    await webViewController!.evaluateJavascript(
      source: "sendRawData(${jsonEncode(jsonString)});",
    );
  }

  Future<void> _sendDataToWebView() async {
    setState(() {
      _isLoading = true;
    });



    try {
      // Передача данных в localStorage с защитой от null
      await webViewController.evaluateJavascript(source: '''
    localStorage.setItem('app_data', JSON.stringify({
      "fcm_token": "${tokenload ?? 'default_fcm_token'}",
      "device_id": "${deviceId ?? 'default_device_id'}",
        "app_name": "Jelly collapse",
      "instance_id": "${instanceId ?? 'default_instance_id'}",
      "platform": "${platform ?? 'unknown_platform'}",
      "os_version": "${osVersion ?? 'default_os_version'}",
      "app_version": "${appVersion ?? 'default_app_version'}",
      "language": "${language ?? 'en'}",
      "timezone": "${timezone ?? 'UTC'}",
      "push_enabled": ${pushEnabled ? 'true' : 'false'}
    }));
  ''');

      final jsonData = {
        "content": {
          "fcm_token": tokenload ?? "default_fcm_token",
          "device_id": deviceId ?? "default_device_id",
          "instance_id": instanceId ?? "default_instance_id",
          "platform": platform ?? "unknown_platform",
          "os_version": osVersion ?? "default_os_version",
          "app_version": appVersion ?? "default_app_version",
          "language": language ?? "en",
          "timezone": timezone ?? "UTC",
          "push_enabled": pushEnabled,
        }
      };

      // Отправка данных на сервер
      await sendDataToServer(jsonData);

      // Конвертируем в строку
      final jsonString = jsonEncode(jsonData);
      //    _showMessage("Данные успешно загружены в localStorage! "+jsonString);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Функция для отправки POST-запроса
  Future<void> sendDataToServer(Map<String, dynamic> data) async {
    const String url = "https://push-app-mig7h.ondigitalocean.app/api/v1/push";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        debugPrint("Данные успешно отправлены на сервер: ${response.body}");
      } else {
        debugPrint("Ошибка при отправке данных: ${response.statusCode}");
        debugPrint("Ответ от сервера: ${response.body}");
      }
    } catch (e) {
      debugPrint("Ошибка сети при отправке данных: $e");
    }
  }
  void _showTopNotification(BuildContext context, RemoteMessage? message, final imageUrl) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Прозрачный фон
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  if (overlayEntry.mounted) {
                    overlayEntry.remove();
                  }
                  if (message?.data['uri'] != null) {
                    SetUrl(message!.data['uri'].toString());
                  } else {
                    setemptyUrl();
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "webnew • now",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (overlayEntry.mounted) {
                              overlayEntry.remove();
                            }
                          },
                          child: Icon(Icons.close, color: Colors.grey[600]), // Крестик для закрытия
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      message?.notification?.title ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      message?.notification?.body ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl ?? "https://via.placeholder.com/350x150",
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          size: 150,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);


  }
  Future<void> _initializeATT() async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 1000));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }
  void InitFlyer() {
    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: appsDevID,
      appId: "6744022823",
      showDebug: true,
    );

    _appsflyerSdk = AppsflyerSdk(options);

    _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    // Starting the SDK with optional success and error callbacks
    _appsflyerSdk.startSDK(
      onSuccess: () {
        print("AppsFlyer SDK initialized successfully.");
      },
      onError: (int errorCode, String errorMessage) {
        print(
          "Error initializing AppsFlyer SDK: Code $errorCode - $errorMessage",
        );
      },
    );
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      setState(() {
        resLoad = res;
        ConVData = resLoad.toString();

        //   print("onAppOpenAttribution res: "+resLoad.toString());
        is_first_launch = resLoad['payload']['is_first_launch'].toString();
        af_status = resLoad['payload']['af_status'].toString();
        install_time = resLoad['payload']['install_time'].toString();
        af_message = resLoad['payload']['af_message'].toString();
        campaign = resLoad['payload']['campaign'].toString();
        campaign_id = resLoad['payload']['campaign_id'].toString();
        fbp = resLoad['payload']['fbp'];
        fbc = resLoad['payload']['fbc'];

        //posBack=_gcd['payload']['campaign'];
        //   print("onInstallConversionData res: " + posBack);
      });
    });

    Future<String?> stringFlyer = _appsflyerSdk.getAppsFlyerUID().then((value) {
      setState(() {
        FlyerId = value.toString();
      });

      print("vaueFlayer " + value.toString());
    });
  }
  void handleUri(String uri) {
    print("Обработка URI: $uri");


    SetUrl(uri);
    // Здесь вы можете перенаправить пользователя на нужный экран или выполнить другое действие
  }

  String? currentUri; // Переменная для хранения текущего URI
  bool _isHandlerSet = false;
  // Диалог для уведомлений с WebView.
  static const MethodChannel _notificationChannel = MethodChannel('com.example.fcm/notification');
  @override
  Widget build(BuildContext context) {

    // Обработка данных уведомлений
    _notificationChannel.setMethodCallHandler((call) async {
      if (call.method == "onNotificationTap") {
        final Map<String, dynamic> notificationData = Map<String, dynamic>.from(call.arguments);
        print("Получены данные из background уведомления: $notificationData");
        //  _showMessage(context, notificationData["uri"].toString(), "");
        String ur="";
        setState(() {
          ur=notificationData["uri"];
        });
        //  String ur=notificationData["uri"];
        // Извлекаем URI
        if (ur!=null && !ur.contains("Нет URI")) {
          String uri = notificationData["uri"];
          print("Получен URI: $uri");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => pusWeb(url: uri)),
                (route) => false, // Удаляем все предыдущие экраны
          );
          // loadToServerOlegTWO();
          //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => pusWeb(url: uri)),
          // );
          // Дальнейшие действия с URI

        }
        // Выполните действия на основе данных уведомления
      }
    });
    return Scaffold(


      body: Stack(
        children: [
          InAppWebView(

            initialSettings: InAppWebViewSettings(
              contentBlockers: contentBlockers,
              javaScriptEnabled: true, // Enable JavaScript
              javaScriptCanOpenWindowsAutomatically: true, // Allow JS to open new windows
            ),

            onWebViewCreated: (controller) {
              webViewController = controller;

              webViewController?.addJavaScriptHandler(
                  handlerName: 'onServerResponse',
                  callback: (args) {
                    // Here you receive all the arguments from the JavaScript side
                    // that is a List<dynamic>
                    print("From the JavaScript side:");
                    print(args);
                    return args.reduce((curr, next) => curr + next);
                  });
            },
            onLoadStop: (controller, url) async {
              // The page has fully loaded, so call _sendDataToWebView here
              debugPrint("Page loaded: $url");

              debugPrint("Page loaded: $url");

              await controller.evaluateJavascript(
                source: """
            console.log('Hello from JavaScript!');
            console.error('This is an error log from JavaScript!');
          """,
              );
              await _sendDataToWebView();
            },

            /*     onReceivedHttpAuthRequest: (controller, challenge) async {
              // Pre-fill the username and leave the password blank
              return HttpAuthResponse(
                username: "rollxo-stg", // Replace with the username you want to pre-fill
                password: "988752", // Leave password blank to show the native dialog
                action: HttpAuthResponseAction.PROCEED,
              );
            },*/
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              //   final url = navigationAction.request.url.toString();

              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }


}
class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}


class BackgroundMessageHandler {
  static const MethodChannel _channel = MethodChannel('com.example.fcm/background');

  /// Listener for background messages
  static void listenForBackgroundMessages(Function(String? title, String? body, String? uri) onMessageReceived) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'handleMessageBackground') {
        final Map<dynamic, dynamic> arguments = call.arguments as Map<dynamic, dynamic>;

        // Извлечение title, body и uri
        final String? title = arguments['title'] as String?;
        final String? body = arguments['body'] as String?;
        final String? uri = arguments['uri'] as String?;

        print("Сообщение из background: title=$title, body=$body, uri=$uri");

        // Вызов коллбэка с полученными данными
        onMessageReceived(title, body, uri);
      }
    });
  }
}
class NotificationTapListener {
  static const MethodChannel _channel = MethodChannel('com.example.fcm/notification');

  /// Listener for notification taps
  static void listenForNotificationTaps(Function(String? uri, String? title, String? body) onNotificationTap) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNotificationTap') {
        final Map<String, dynamic> data = Map<String, dynamic>.from(call.arguments);
        print("Данные уведомления из iOS: $data");

        // Получение title, body и uri
        final String? uri = data['uri'];
        final String? title = data['title'];
        final String? body = data['body'];

        print("URI: $uri");

        // Вызов коллбэка с данными
        onNotificationTap(uri, title, body);
      }
    });
  }
}