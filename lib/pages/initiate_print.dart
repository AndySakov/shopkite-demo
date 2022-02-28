import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopkite_demo/models/product.dart';
import 'package:shopkite_demo/services/printer_service.dart';
import 'package:shopkite_demo/services/service_locator.dart';

class InitiatePrint extends StatefulWidget {
  const InitiatePrint({Key? key, required this.products}) : super(key: key);

  final List<Product> products;

  @override
  _InitiatePrintState createState() => _InitiatePrintState();
}

class _InitiatePrintState extends State<InitiatePrint> {
  final PrinterService printerService = serviceLocator<PrinterService>();
  String connectedDevice = '';

  Future<Widget> _getBluetoothDevices() async {
    List<dynamic>? availableBluetoothDevices =
        await printerService.getBluetooth();
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Select Printer Device',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: availableBluetoothDevices!.isNotEmpty
                ? availableBluetoothDevices.length
                : 0,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  String select = availableBluetoothDevices[index];
                  List list = select.split("#");
                  String mac = list[1];
                  if (await printerService.setConnect(mac)) {
                    setState(() {
                      connectedDevice = list[0];
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Connection to ${list[0]} failed!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                    );
                  }
                },
                title: Text('${availableBluetoothDevices[index]}'),
                subtitle: const Text("Click to connect"),
              );
            },
          ),
        ),
        (await printerService.isConnected()
            ? Text('Connected to $connectedDevice')
            : const SizedBox(
                height: 10,
              ))
      ],
    );
  }

  void _printTicket() async {
    printerService.printTicket(widget.products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Printer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: _getBluetoothDevices(),
            builder: (context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return snapshot.data ??
                    const Text('No bluetooth devices found!');
              }
            },
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton.icon(
            onPressed: (connectedDevice == '' ? null : () => _printTicket()),
            icon: const Icon(Icons.print),
            label: const Text('Print Ticket'),
          )
        ],
      ),
    );
  }
}
