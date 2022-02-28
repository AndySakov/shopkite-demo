import 'package:shopkite_demo/services/ws_service.dart';
import 'package:shopkite_demo/widgets/coin_buttons.dart';
import 'package:shopkite_demo/widgets/coin_value.dart';
import 'package:flutter/material.dart';

class WebsocketsDemo extends StatefulWidget {
  WebsocketsDemo({Key? key}) : super(key: key);

  final WSService provider = WSService();

  @override
  State<WebsocketsDemo> createState() => _WebsocketsDemoState();
}

class _WebsocketsDemoState extends State<WebsocketsDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Sockets Demo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: CoinValue(
                provider: widget.provider,
              ),
              flex: 4,
            ),
            Expanded(
              flex: 2,
              child: CoinButtons(
                provider: widget.provider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
