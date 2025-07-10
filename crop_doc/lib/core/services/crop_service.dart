import 'dart:convert';
import 'package:crop_doc/core/database/models/crops.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://10.2.14.163:8000/api';

Future<List<Crop>> fetchCropsFromServer() async {
  final res = await http.get(Uri.parse('$baseUrl/crops'));

  if (res.statusCode == 200) {
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((item) => Crop.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load crops');
  }
}
