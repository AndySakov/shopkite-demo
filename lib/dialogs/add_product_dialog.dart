import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:shopkite_demo/models/product.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({Key? key}) : super(key: key);

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final productNameController = TextEditingController();
  int _productID = 0;
  String _productName = '';
  double _productPrice = 0.0;
  Product _currentProduct = Product(id: 0, name: 'null', price: 0.0);

  @override
  void dispose() {
    productNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView(
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Center(
                child: Text(
                  'Add a new Product',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black54),
                ),
              )),
          const Divider(
            color: Colors.deepOrangeAccent,
            height: 20,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: TextField(
              controller: productNameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Product Name',
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Product Price',
            ),
          ),
          DecimalNumberPicker(
            value: _productPrice,
            minValue: 0,
            maxValue: 100000,
            decimalPlaces: 2,
            onChanged: (value) => setState(() => _productPrice = value),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.deepOrangeAccent,
            height: 20,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _currentProduct);
                },
                child: const Text('Close'),
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              ),
              ElevatedButton(
                onPressed: () {
                  _productName = productNameController.text;
                  _currentProduct = Product(
                    id: _productID,
                    name: _productName,
                    price: _productPrice,
                  );
                  setState(() {
                    _productID++;
                  });
                  Navigator.pop(context, _currentProduct);
                },
                child: const Text('Done'),
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              )
            ],
          )
        ],
      ),
      height: 435,
    );
  }
}
