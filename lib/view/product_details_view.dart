import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screening_task_ci/model/product_model.dart';
import 'package:screening_task_ci/viewmodel/product_details_viewmodel.dart';

class ProductDetailsView extends StatelessWidget {
  final String productId;
  const ProductDetailsView({this.productId=""});
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductDetailsViewModel>(context);
    viewModel.handleProductIdFromPageNavigation(productId);
    return Scaffold(
      appBar: AppBar(title: Text("Product details "+productId)),
      /// Lazy load Product details using FutureBuilder
      body: FutureBuilder<Product>(
        future: viewModel.fetchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final product = snapshot.data!;
            return Column(
              children: [
                ListTile(
                  title: Text('\$${product.title}'),
                  subtitle:Text('Price: \$${product.price}'),
                ),
                // Other product details
              ],
            );
          }
        },
      ),
    );
  }
}
