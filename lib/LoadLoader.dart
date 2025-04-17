import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadLoader extends StatefulWidget {
  String? token;
  LoadLoader(this.token);

  @override
  State<LoadLoader> createState() => _LoadLoaderState(token);
}

class _LoadLoaderState extends State<LoadLoader> {
  String title = "https://bonunza.com/rzkvgK";
  String? token;
  _LoadLoaderState(this.token);
  var contentBlockerEnabled = true;
  final List<ContentBlocker> contentBlockers = [];

  InAppWebViewController? webViewController;

  @override
  void initState() {
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canNavigate = await webViewController!.canGoBack();
        if (canNavigate) {
          webViewController!.goBack();
        } else {
          //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CheckBox()),
          //  ModalRoute.withName("/Home")
          //    );
        }

        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 3,
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(15.0), // here the desired height
            child: AppBar(
              backgroundColor: Colors.black,
              // ...
            )),
        body: Stack(children: [
          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 13.0,
            animation: true,
            percent: 0.7,
            center: new Text(
              "70.0%",
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(title)),
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              //   getUrlLocation(url.toString());
            },
            onPermissionRequest: (controller, permissionRequest) async {
              await Permission.camera.request();
              await Permission.microphone.request();
              return PermissionResponse(
                  resources: permissionRequest.resources,
                  action: PermissionResponseAction.GRANT);
            },
            initialSettings: InAppWebViewSettings(
                disableDefaultErrorPage: true,
                contentBlockers: contentBlockers,
                userAgent: ""),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onReceivedHttpError: (controller, request, errorResponse) async {},
            onReceivedError: (controller, request, error) async {},
          ),
        ]),
      ),
    );
  }
}

final FILT = [
  ".*.doubleclick.net/.*",
  ".*.ads.pubmatic.com/.*",
  ".*.googlesyndication.com/.*",
  ".*.google-analytics.com/.*",
  ".*.adservice.google.*/.*",
  ".*.adbrite.com/.*",
  ".*.exponential.com/.*",
  ".*.quantserve.com/.*",
  ".*.scorecardresearch.com/.*",
  ".*.zedo.com/.*",
  ".*.adsafeprotected.com/.*",
  ".*.teads.tv/.*",
  ".*.outbrain.com/.*",
];
