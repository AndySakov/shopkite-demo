import 'package:flutter/material.dart';
import 'package:shopkite_demo/services/ws_service.dart';
import 'package:shopkite_demo/widgets/coin_price.dart';

class CoinValue extends StatefulWidget {
  final WSService provider;

  const CoinValue({
    required this.provider,
    Key? key,
  }) : super(key: key);

  @override
  State<CoinValue> createState() => _CoinValueState();
}

class _CoinValueState extends State<CoinValue> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Watching Coins:",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(
                  color: Colors.blueAccent,
                  width: 2.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CoinPrice(
                    color: Colors.blue,
                    stream: widget.provider.ethStream,
                  ),
                  CoinPrice(
                    color: Colors.orange,
                    stream: widget.provider.bitcoinStream,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
