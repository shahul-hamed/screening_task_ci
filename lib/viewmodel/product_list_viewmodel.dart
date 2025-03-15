import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:screening_task_ci/app/app_api.dart';
import 'package:screening_task_ci/app/app_utility.dart';
import 'dart:convert';

import 'package:screening_task_ci/model/product_model.dart';

class ProductListViewModel extends ChangeNotifier {

  List<Product> get products => _products;
  List<Product> _products = [];

  Future<void> loadProducts() async {
    /// initialize hive box
    final box = await Hive.openBox('products');
    /// check internet availability
    if(!await AppUtility.isInternet()) {
      /// fetch data from local database
      _products = box.values.toList().cast<Product>();
    }
    else {
      /// fetch products from API
        final response = await http.get(Uri.parse(AppApi.productListApi));
        debugPrint("status${response.statusCode}");
        final List data = json.decode(response.body);
        List<Product> productList = data.map((item) =>
            Product(
              id: item['id'].toString(),
              title: item['title'],
              price: item['price'],
            )).toList();

        _products = productList;

        /// Save to local store
        for (var product in productList) {
          await box.add(product);
        }
    }

  }
}
