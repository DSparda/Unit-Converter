// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';
import 'package:dio/dio.dart';

const apiCategory = {
  'name': 'Currency',
  'route': 'currency',
};

class Api {
  final HttpClient _httpClient = HttpClient();

  final String _url = 'flutter.udacity.com';

  Future<List> getUnits(String category) async {
    final uri = Uri.https(_url, '/$category');
    final jsonResponse = await _getJsonByDio(uri);
    if (jsonResponse == null || jsonResponse['units'] == null) {
      print('Error retrieving units.');
      return null;
    }
    return jsonResponse['units'];
  }

  Future<double> convert(
      String category, String amount, String fromUnit, String toUnit) async {
    final uri = Uri.https(_url, '/$category/convert',
        {'amount': amount, 'from': fromUnit, 'to': toUnit});
    final jsonResponse = await _getJsonByDio(uri);
    if (jsonResponse == null || jsonResponse['status'] == null) {
      print('Error retrieving conversion.');
      return null;
    } else if (jsonResponse['status'] == 'error') {
      print(jsonResponse['message']);
      return null;
    }
    return jsonResponse['conversion'].toDouble();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.ok) {
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();

      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  Future<Map<String, dynamic>> _getJsonByDio(Uri uri) async {
    try {
      Response response;
      Dio dio = new Dio();
      response = await dio.getUri(uri);
      if (response.statusCode != HttpStatus.ok) {
        return null;
      }
      return json.decode(response.data);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}
