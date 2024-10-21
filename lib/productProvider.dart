import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<String> uploadImage(File image) async {
    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      TaskSnapshot snapshot = await storageRef.putFile(image);
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return ''; // Return an empty string on error
    }
  }

  Future<void> addProduct(String name, double price, File image, BuildContext context) async {
    if (name.isEmpty || price <= 0 || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setLoading(true);

    try {
      print("Uploading image...");
      String imageUrl = await uploadImage(image);
      print("Image URL: $imageUrl");

      if (imageUrl.isNotEmpty) {
        String newId = generateRandomId();
        print("Adding product to Firestore...");

        // Use .set() with the custom ID to store the product
        await FirebaseFirestore.instance.collection('products').doc(newId).set({
          'id': newId,
          'name': name,
          'price': price,
          'imageUrl': imageUrl,
        });

        // Add to the local products list
        _products.add({
          'id': newId, // Store the custom ID
          'name': name,
          'price': price,
          'imageUrl': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
      }
    } catch (e) {
      print("Error adding product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product')),
      );
    } finally {
      setLoading(false);
    }
  }

  String generateRandomId() {
    Random random = Random();
    int randomNumber = random.nextInt(1000000); // Generates a random number up to 1,000,000
    return 'product_$randomNumber'; // Example format: product_123456
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();

      // Remove from local list
      _products.removeWhere((product) => product['id'] == productId);
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> fetchProducts() async {
    setLoading(true);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();
      _products = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      notifyListeners(); // Notify listeners after fetching products
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      setLoading(false);
    }
  }
}
