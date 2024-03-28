import 'package:customerapp/product/product_home.dart';
import 'package:customerapp/screen/create_bottom.dart';
import 'package:customerapp/screen/update_bottom.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

final customersReference = FirebaseDatabase.instance.ref("customersData");

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 208, 227, 243),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 95, 158),
        elevation: 5,
        centerTitle: true,
        title: Text(
          "CUSTOMERS",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            fontStyle: FontStyle.italic,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: customersReference.orderByChild("id"),
              itemBuilder: (context, snapshot, index, animation) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      snapshot.child("name").value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address: ${snapshot.child("address").value.toString()}'), 
                        Text('Phone: ${snapshot.child("phone").value.toString()}'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              updateCustomerBottomSheet(
                                context,
                                snapshot.child("name").value.toString(),
                                snapshot.child("id").value.toString(),
                                snapshot.child("address").value.toString(), 
                                snapshot.child("phone").value.toString(),
                              );
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text("Edit"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              customersReference
                                  .child(snapshot.child('id').value.toString())
                                  .remove();
                            },
                            leading: const Icon(Icons.delete),
                            title: const Text("Delete"),
                          ),
                        )
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => createCustomerBottomSheet(context),
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BeautyProductsScreen()),
              );
            },
            child: Icon(Icons.home),
            backgroundColor: Color.fromARGB(255, 224, 230, 236),
          ),
        ],
      ),
    );
  }
}
