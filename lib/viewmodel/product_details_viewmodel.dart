// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:screening_task_ci/app/app_api.dart';
import 'package:screening_task_ci/app/app_utility.dart';
import 'package:screening_task_ci/model/product_model.dart';
import 'package:http/http.dart' as http;


class ProductDetailsViewModel extends ChangeNotifier {
  String? _productId;

  Product _product = Product(id: "", title: "", price: 0);

  String? get productId => _productId;
  Product get product => _product;

  void handleDeepLink(Uri deepLink) {
    if (deepLink.pathSegments.isNotEmpty) {
      _productId = deepLink.pathSegments.last;
      notifyListeners();
    }
  }

  handleProductIdFromPageNavigation(dynamic id) {
    if (id != 0) {
      _productId = id.toString();
      notifyListeners();
    }
  }

  Future<Product> fetchProductDetails() async {
    // Assume we are using an API call or local database here.
    /// initialize hive box
    final box = await Hive.openBox('products');
    /// check internet availability
    if(!await AppUtility.isInternet()) {
      /// fetch data from local database
      final _products = box.values.toList().cast<Product>();
      final data = _products.where((e)=>e.id == productId).toList();
      if(data.isNotEmpty) {
        _product = data.first;
      }
    }
    else {
      try {
        final response = await http.get(
            Uri.parse(AppApi.productListApi + productId.toString()));

        /// getting specific product details
        final data = json.decode(response.body);
        _product = Product(
          id: data['id'].toString(),
          title: data['title'],
          price: data['price'],
        );

        /// Save to local store
        await box.add(_product);
      }
      catch (e) {
        debugPrint(e.toString());
      }
    }
    return product;
  }
}
