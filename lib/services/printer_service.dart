import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:shopkite_demo/models/product.dart';

class PrinterService {
  PrinterService._privateConstructor();
  static final PrinterService instance = PrinterService._privateConstructor();

  Future<List<dynamic>?> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    debugPrint("Print $bluetooths");
    return bluetooths;
  }

  Future<bool> setConnect(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);
    debugPrint("state conneected $result");
    if (result == "true") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isConnected() async {
    return await BluetoothThermalPrinter.connectionStatus == "true";
  }

  Future<void> printTicket(List<Product> products) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(products);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      debugPrint("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<List<int>> getTicket(List<Product> products) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text("Shopkite Demo",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text("Somewhere in Lagos, Nigeria, Africa, Earth ;-)",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: +234 567 890 1234',
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'No',
          width: 2,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Product',
          width: 6,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Price',
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    products.asMap().forEach((index, product) {
      bytes += generator.row([
        PosColumn(text: '${index + 1}', width: 2),
        PosColumn(
            text: product.name,
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: '${product.price}',
            width: 4,
            styles: const PosStyles(
              align: PosAlign.center,
            )),
      ]);
    });

    bytes += generator.text('================');

    double total =
        products.map((e) => e.price).fold(0, (prev, curr) => prev + curr);

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: total.toStringAsFixed(2),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    bytes += generator.text('================');

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text('${DateTime.now()}',
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text(
        'Note: Goods once sold will not be taken back or exchanged.',
        styles: const PosStyles(align: PosAlign.center, bold: false));

    bytes += generator.qrcode('shopkite.com.ng');

    bytes += generator.hr();

    // Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    bytes += generator.cut();
    return bytes;
  }
}
