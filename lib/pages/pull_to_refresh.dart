import 'package:flutter/material.dart';

class PullToRefreshDemo extends StatefulWidget {
  const PullToRefreshDemo({Key? key}) : super(key: key);

  @override
  _PullToRefreshDemoState createState() => _PullToRefreshDemoState();
}

class _PullToRefreshDemoState extends State<PullToRefreshDemo> {
  List<String> items = ['Food', 'Water', 'Shelter'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pull to Refresh Demo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2));
            setState(() {
              items.add('Exercise');
            });
          },
          child: ListView(
            children: items
                .map((e) => ListTile(
                        title: Center(
                      child: Text(
                        e,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )))
                .toList(),
          )),
    );
  }
}
