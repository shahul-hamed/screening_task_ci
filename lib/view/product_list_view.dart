import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screening_task_ci/viewmodel/product_list_viewmodel.dart';

import 'product_details_view.dart';

class ProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductListViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Products')),

      /// Lazy load Product list using FutureBuilder
      body: FutureBuilder(
        future: viewModel.loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.separated(
              itemCount: viewModel.products.length,
              separatorBuilder: (context,index)=>Divider(),
              itemBuilder: (context, index) {
                final product = viewModel.products[index];
                return InkWell(
                  onTap: (){
                    /// navigate to details page
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsView(productId: product.id,)));
                  },
                  child: ListTile(
                    title: Text(product.title,style: TextStyle(fontSize: 16),),
                    subtitle: Text('Price: \$${product.price}',style: TextStyle(color: Colors.green,fontSize: 16),),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
