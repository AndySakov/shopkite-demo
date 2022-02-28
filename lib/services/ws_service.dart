import 'dart:async';
import 'dart:convert';

import 'package:shopkite_demo/models/coinbase_request.dart';
import 'package:shopkite_demo/models/coinbase_response.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WSService {
  late final WebSocketChannel _ethWebsocket;

  late final WebSocketChannel _btcWebsocket;

  static const _btcProduct = "BTC-EUR";

  static const _ethProduct = "ETH-EUR";

  WSService()
      : _ethWebsocket = WebSocketChannel.connect(
          Uri.parse('wss://ws-feed.pro.coinbase.com'),
        ),
        _btcWebsocket = WebSocketChannel.connect(
          Uri.parse('wss://ws-feed.pro.coinbase.com'),
        );

  Stream<CoinbaseResponse> get bitcoinStream => _btcWebsocket.stream
      .map<CoinbaseResponse>(
          (value) => CoinbaseResponse.fromJson(jsonDecode(value)))
      .skipWhile((element) => element.productId != _btcProduct);

  Stream<CoinbaseResponse> get ethStream => _ethWebsocket.stream
      .map<CoinbaseResponse>(
          (value) => CoinbaseResponse.fromJson(jsonDecode(value)))
      .skipWhile((element) => element.productId != _ethProduct);

  void openBitcoin() {
    _btcWebsocket.sink.add(
      jsonEncode(
        CoinbaseRequest(
          'subscribe',
          [
            {
              "name": "ticker",
              "product_ids": [_btcProduct]
            }
          ],
        ).toJson(),
      ),
    );
  }

  void closeBitcoin() {
    _btcWebsocket.sink.close();
  }

  void openEthereum() {
    _ethWebsocket.sink.add(
      jsonEncode(
        CoinbaseRequest(
          'subscribe',
          [
            {
              "name": "ticker",
              "product_ids": [_ethProduct]
            }
          ],
        ).toJson(),
      ),
    );
  }

  void closeEthereum() {
    _ethWebsocket.sink.close();
  }
}
