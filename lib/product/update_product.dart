import 'package:flutter/material.dart';
import 'package:customerapp/product/product_home.dart';

final TextEditingController beautyProductNameController = TextEditingController();
final TextEditingController beautyProductPriceController = TextEditingController();
final TextEditingController beautyProductQuantityController = TextEditingController();

void updateBeautyProductsBottomSheet(BuildContext context, String name, String id, String price, String quantity) {
  beautyProductNameController.text = name;
  beautyProductPriceController.text = price;
  beautyProductQuantityController.text = quantity;

  bool nameIsValid = true;
  bool priceIsValid = true;
  bool quantityIsValid = true;

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: const Color.fromARGB(255, 208, 227, 243),
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    "Update your beauty product",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: beautyProductNameController,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    hintText: "eg. Lipstick",
                    errorText: nameIsValid ? null : "Invalid Product Name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      nameIsValid = _validateProductName(value);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: beautyProductPriceController,
                  decoration: InputDecoration(
                    labelText: "Price",
                    hintText: "eg. 10.99",
                    errorText: priceIsValid ? null : "Invalid Price",
                  ),
                  onChanged: (value) {
                    setState(() {
                      priceIsValid = _validatePrice(value);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: beautyProductQuantityController,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    hintText: "eg. 50",
                    errorText: quantityIsValid ? null : "Invalid Quantity",
                  ),
                  onChanged: (value) {
                    setState(() {
                      quantityIsValid = _validateQuantity(value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (nameIsValid && priceIsValid && quantityIsValid) {
                      beautyProductsReference.child(id).update({
                        "name": beautyProductNameController.text.toString(),
                        "price": beautyProductPriceController.text.toString(),
                        "quantity": beautyProductQuantityController.text.toString(),
                      });

                      beautyProductNameController.clear();
                      beautyProductPriceController.clear();
                      beautyProductQuantityController.clear();
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter valid information'),
                        ),
                      );
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

bool _validateProductName(String name) {
  // Check if name is not empty
  return name.isNotEmpty;
}

bool _validatePrice(String price) {
  // Check if price is a valid number
  final RegExp regex = RegExp(r'^\d+(\.\d+)?$');
  return regex.hasMatch(price);
}

bool _validateQuantity(String quantity) {
  // Check if quantity is a valid number
  final RegExp regex = RegExp(r'^\d+$');
  return regex.hasMatch(quantity);
}
