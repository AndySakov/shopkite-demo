import 'package:flutter/material.dart';
import 'package:shopkite_demo/models/coinbase_response.dart';

class CoinPrice extends StatelessWidget {
  final Stream<CoinbaseResponse> stream;
  final Color color;

  const CoinPrice({
    required this.stream,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<CoinbaseResponse> snapshot) {
          /// We are waiting for incoming data data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// We have an active connection and we have received data
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            return Center(
              child: Text(
                '${snapshot.data!.productId}: ${snapshot.data!.price}',
                style: TextStyle(
                  color: color,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          /// When we have closed the connection
          if (snapshot.connectionState == ConnectionState.done) {
            return const Center(
              child: Text(
                'No more data',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }

          /// For all other situations, we display a simple "No data"
          /// message
          return const Center(
            child: Text('No data'),
          );
        },
      ),
    );
  }
}