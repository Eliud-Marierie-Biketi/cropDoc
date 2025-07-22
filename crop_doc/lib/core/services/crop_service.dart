import 'dart:convert';
import 'package:crop_doc/core/constants/app_strings.dart';
import 'package:crop_doc/core/database/models/crops.dart';
import 'package:http/http.dart' as http;

Future<List<Crop>> fetchCropsFromServer() async {
  final res = await http.get(Uri.parse('$baseUrl/crops'));

  if (res.statusCode == 200) {
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((item) => Crop.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load crops');
  }
}
