import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class showProductApi with ChangeNotifier {
  List products = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<List<dynamic>> fetchProducts() async {
    print("object");

    final Dio _dio = Dio();

    try {
      final Response response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        print("objectobjectobjectobjectobject");
        products = response.data;
        notifyListeners();
        return response.data;
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Server-side error
        print("Server Error: ${e.response?.statusCode} ${e.response?.data}");
        throw Exception('Failed to load products. Server Error: ${e.response?.statusCode}');
      } else {
        // Client-side error (like timeout, connectivity issues, etc.)
        print("Client Error: ${e.message}");
        throw Exception('Failed to load products. Client Error: ${e.message}');
      }
    } catch (e) {
      print("Unknown Error: $e");
      throw Exception('An unknown error occurred');
    }
  }


}
