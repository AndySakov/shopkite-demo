import 'package:flutter/material.dart';
import 'package:shopkite_demo/services/service_locator.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCDemo extends StatefulWidget {
  const NFCDemo({Key? key}) : super(key: key);

  @override
  _NFCDemoState createState() => _NFCDemoState();
}

class _NFCDemoState extends State<NFCDemo> {
  bool _supportsNFC = false;
  final NfcManager nfcManager = serviceLocator<NfcManager>();
  bool _hasScannedTag = false;
  String _modalMessage = "";
  NfcTag? _tag;

  @override
  void initState() {
    super.initState();
    // Check if the device supports NFC reading
    _getNfcSupport();
    _modalMessage = _hasScannedTag == true ? "Tag found!" : "Scanning tag...";
  }

  void _getNfcSupport() async {
    bool nfcSupport = await nfcManager.isAvailable();
    setState(() {
      _supportsNFC = nfcSupport;
    });
  }

  Widget _tagData() {
    if (_hasScannedTag) {
      return const Text("Tag Scanned!");
    } else {
      return const Text("No Scanned Tag!");
    }
  }

  Widget _pageData() {
    if (_supportsNFC) {
      return Column(
        children: <Widget>[
          Center(
            child: Text(
              "NFC supported!",
              style: TextStyle(
                color: Colors.green.shade600,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: !_hasScannedTag == true
                                ? const CircularProgressIndicator()
                                : const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                          ),
                          Center(
                            child: Text(_modalMessage),
                          ),
                        ],
                      );
                    });
                nfcManager.startSession(
                  onDiscovered: (NfcTag tag) async {
                    setState(() {
                      _tag = tag;
                      _hasScannedTag = true;
                    });
                  },
                );

                nfcManager.stopSession();
              },
              child: const Text("Scan tags"),
            ),
          ),
          _tagData()
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      return Column(
        children: <Widget>[
          Center(
            child: Text(
              "Either your device doesn't support NFC or you have it disabled.",
              style: TextStyle(
                  color: Colors.deepOrange.shade900,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "Check your device settings to see if your device supports NFC and enable it.",
              style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip),
            ),
          ),
          Center(
            child: Text(
              "Then pull down to refresh.",
              style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC Scanner Demo'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: RefreshIndicator(
          child: ListView(
            children: <ListTile>[
              ListTile(
                title: _pageData(),
              )
            ],
          ),
          onRefresh: () async {
            _getNfcSupport();
          },
        ));
  }
}
