import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shopkite_demo/models/product.dart';
import 'package:shopkite_demo/dialogs/add_product_dialog.dart';
import 'package:shopkite_demo/dialogs/export_products_dialog.dart';
import 'package:shopkite_demo/services/db_service.dart';
import 'package:shopkite_demo/services/service_locator.dart';

class DocsAndRecords extends StatefulWidget {
  const DocsAndRecords({Key? key}) : super(key: key);

  @override
  _DocsAndRecordsState createState() => _DocsAndRecordsState();
}

class _DocsAndRecordsState extends State<DocsAndRecords> {
  DbService dbService = serviceLocator<DbService>();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProductsFromDb();
  }

  void _loadProductsFromDb() async {
    var products = await dbService.getProductList();
    setState(() {
      _products = products;
    });
  }

  List<DataRow> _getTableData() {
    return _products
        .asMap()
        .map((index, product) => MapEntry(
            index,
            DataRow(cells: <DataCell>[
              DataCell(Text('${index + 1}')),
              DataCell(Text(product.name)),
              DataCell(Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(overflow: TextOverflow.clip),
              )),
              DataCell(
                IconButton(
                  onPressed: () {
                    dbService.deleteProduct(product);
                    setState(() {
                      _products.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.cancel),
                  padding: EdgeInsets.zero,
                  iconSize: 10,
                ),
              ),
            ])))
        .values
        .toList();
  }

  void _addNewProduct(Product newProduct) {
    if (newProduct.name == '' && newProduct.price >= 0.0) {
      Fluttertoast.showToast(
        msg: 'Product name cannot be empty!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );
    } else if (newProduct.name == 'null') {
    } else {
      dbService.insertProduct(newProduct);
      setState(() {
        _products.add(newProduct);
      });
      Fluttertoast.showToast(
        msg: 'Added new product!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  Widget _pageData() {
    return Center(
      child: ListView(
        children: <Widget>[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Products Records',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                  label: Text('S/N',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Name',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Price',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('*',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
            ],
            rows: _getTableData(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents and Records Demo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: _pageData(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              try {
                Product newProduct = await showDialog(
                  context: this.context,
                  builder: (BuildContext context) {
                    return const Dialog(
                      child: AddProductDialog(),
                    );
                  },
                );
                _addNewProduct(newProduct);
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            child: const Icon(Icons.add),
            heroTag: 'add',
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: this.context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: ExportProductsDialog(products: _products),
                  );
                },
              );
            },
            child: const Icon(Icons.share),
            heroTag: 'export',
          ),
        ],
      ),
    );
  }
}
