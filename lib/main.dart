import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shopkite_demo/dialogs/hyperlink_dialog.dart';
import 'package:shopkite_demo/pages/api_demo.dart';
import 'package:shopkite_demo/pages/barcode_scanner.dart';
import 'package:shopkite_demo/pages/document_and_records.dart';
import 'package:shopkite_demo/pages/nfc_demo.dart';
import 'package:shopkite_demo/pages/pull_to_refresh.dart';
import 'package:shopkite_demo/pages/websockets_demo.dart';
import 'package:shopkite_demo/services/service_locator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() {
  setupServiceLocators();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);
  runApp(const MyApp());
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      debugPrint("Set as foreground request");
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      debugPrint("Set as background request");
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      debugPrint("Stop service request");
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );

    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });
}

class BGServiceDemo extends StatefulWidget {
  const BGServiceDemo({Key? key}) : super(key: key);

  @override
  _BGServiceDemoState createState() => _BGServiceDemoState();
}

class _BGServiceDemoState extends State<BGServiceDemo> {
  String text = "Stop Service";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service App'),
      ),
      body: Column(
        children: [
          StreamBuilder<Map<String, dynamic>?>(
            stream: FlutterBackgroundService().onDataReceived,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final data = snapshot.data!;
              DateTime? date = DateTime.tryParse(data["current_date"]);
              return Text(date.toString());
            },
          ),
          ElevatedButton(
            child: const Text("Foreground Mode"),
            onPressed: () {
              FlutterBackgroundService()
                  .sendData({"action": "setAsForeground"});
            },
          ),
          ElevatedButton(
            child: const Text("Background Mode"),
            onPressed: () {
              FlutterBackgroundService()
                  .sendData({"action": "setAsBackground"});
            },
          ),
          ElevatedButton(
            child: Text(text),
            onPressed: () async {
              var isRunning =
                  await FlutterBackgroundService().isServiceRunning();
              if (isRunning) {
                FlutterBackgroundService().sendData(
                  {"action": "stopService"},
                );
              } else {
                FlutterBackgroundService.initialize(onStart);
              }
              if (!isRunning) {
                text = 'Stop Service';
              } else {
                text = 'Start Service';
              }
              setState(() {});
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FlutterBackgroundService().sendData({
            "hello": "world",
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopkite Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Shopkite Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BarcodeScanner()),
                  );
                },
                child: const Text('Barcode Scanner Demo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DocsAndRecords()),
                  );
                },
                child: const Text('Document Printer Demo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: this.context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        child: HyperlinkDialog(),
                      );
                    },
                  );
                },
                child: const Text('Hyperlink Pages Demo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BGServiceDemo()),
                  );
                },
                child: const Text('Background Processes Demo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ApiDemo()),
                  );
                },
                child: const Text('API Demo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PullToRefreshDemo()),
                  );
                },
                child: const Text('PTR Demo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WebsocketsDemo()),
                  );
                },
                child: const Text('WebSockets Demo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NFCDemo()),
                  );
                },
                child: const Text('NFC Demo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
