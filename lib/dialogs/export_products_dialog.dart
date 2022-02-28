import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shopkite_demo/pages/initiate_print.dart';
import 'package:shopkite_demo/models/product.dart';

class ExportProductsDialog extends StatelessWidget {
  const ExportProductsDialog({Key? key, required this.products})
      : super(key: key);

  final List<Product> products;

  List<pw.TableRow> _getTableData() {
    var initial = products
        .asMap()
        .map((index, product) => MapEntry(
            index,
            pw.TableRow(children: <pw.Widget>[
              pw.Text('${index + 1}'),
              pw.Text(product.name),
              pw.Text('\$${product.price}'),
            ])))
        .values
        .toList();
    initial.insert(
        0,
        pw.TableRow(
          children: <pw.Widget>[
            pw.Text(
              'S/N',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 20,
              ),
            ),
            pw.Text(
              'Name',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 20,
              ),
            ),
            pw.Text(
              'Price',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ));
    return initial;
  }

  pw.Document getPdf() {
    var inner = pw.Document();
    inner.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Center(
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Text(
                  'Products Records',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),
            ),
            pw.Table(children: _getTableData())
          ];
        },
      ),
    ); // Page
    return inner;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: <ElevatedButton>[
          ElevatedButton.icon(
            onPressed: () async {
              await Printing.sharePdf(
                  bytes: await getPdf().save(),
                  filename: 'product-records.pdf');
            },
            icon: const Icon(Icons.share),
            label: const Text('Share records as PDF'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await Printing.sharePdf(
                  bytes: await getPdf().save(),
                  filename: 'product-records.pdf');
            },
            icon: const Icon(Icons.share),
            label: const Text('Save records to Local DB'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => getPdf().save());
            },
            icon: const Icon(Icons.print_outlined),
            label: const Text('Print records as PDF'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return InitiatePrint(products: products);
              }));
            },
            icon: const Icon(Icons.print),
            label: const Text('Print records as reciept'),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      height: 250,
    );
  }
}
