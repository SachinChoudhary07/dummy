// pages/products_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskc/show_product_provider_api.dart';

class ShowProductApi extends StatefulWidget {
  @override
  State<ShowProductApi> createState() => _ShowProductApiState();
}


class _ShowProductApiState extends State<ShowProductApi> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<showProductApi>(context, listen: false).fetchProducts();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double mediaQueryHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Products From API'),
      ),
      body: Consumer<showProductApi>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.products.isEmpty) {
            return const Center(
              child: Text('No products available'),
            );
          }

          return ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return ListTile(
                title: Text(product['title']),
                subtitle: Text(product['body']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<showProductApi>(context, listen: false).fetchProducts();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
