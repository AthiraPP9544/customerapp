import 'package:customerapp/product/create_product.dart';
import 'package:customerapp/product/update_product.dart';
import 'package:customerapp/screen/signin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class BeautyProductsScreen extends StatefulWidget {
  const BeautyProductsScreen({Key? key}) : super(key: key);

  @override
  _BeautyProductsScreenState createState() => _BeautyProductsScreenState();
}

final beautyProductsReference =
    FirebaseDatabase.instance.ref("beautyProductsData");

class _BeautyProductsScreenState extends State<BeautyProductsScreen> {
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
          "BEAUTY PRODUCTS",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            fontStyle: FontStyle.italic,
            fontFamily: 'Roboto',
          ),
        ),
         actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
             onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SigninScreen()),
              );
            }, 
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: beautyProductsReference.orderByChild("id"),
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
                        Text(
                            'Price: \$${snapshot.child("price").value.toString()}'),
                        Text(
                            'Quantity: ${snapshot.child("quantity").value.toString()}'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              updateBeautyProductsBottomSheet(
                                context,
                                snapshot.child("name").value.toString(),
                                snapshot.child("id").value.toString(),
                                snapshot.child("price").value.toString(),
                                snapshot.child("quantity").value.toString(),
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
                              beautyProductsReference
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => createBeautyProductsBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}