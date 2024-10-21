// pages/products_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskc/productProvider.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch products when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: productsProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : productsProvider.products.isEmpty
          ? Center(child: Text('No products available.'))
          : ListView.builder(
        itemCount: productsProvider.products.length,
        itemBuilder: (context, index) {
          final product = productsProvider.products[index];
          return ListTile(
            leading: Image.network(product['imageUrl'], width: 50, height: 50),
            title: Text(product['name']),
            subtitle: Text('\$${(product['price'] as num).toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Show a confirmation dialog before deletion
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Product'),
                      content: Text('Are you sure you want to delete this product?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            productsProvider.deleteProduct(product['id']);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
