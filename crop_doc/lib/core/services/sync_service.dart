import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crop_doc/core/database/models/treatment_model.dart';
import 'package:crop_doc/core/database/models/user_stats_model.dart';
import 'package:crop_doc/core/database/models/user_model.dart';
import 'package:crop_doc/core/database/models/crop_model.dart';
import 'package:crop_doc/core/database/models/disease_model.dart';

class SyncService {
  final String baseUrl;

  SyncService(this.baseUrl);

  // 🌱 Fetch crops from the backend (no headers or auth required)
  Future<List<CropModel>> fetchCrops() async {
    final uri = Uri.parse('$baseUrl/api/crops/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) {
        return CropModel(
          id: e['id'] ?? 0,
          cropname: e['cropname'] ?? '',
          description: e['description'] ?? '',
          isSynced: true,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch crops (${response.statusCode})');
    }
  }

  // ------------------------
  // 🔹 TREATMENTS: GET ALL
  // ------------------------
  Future<List<TreatmentModel>> fetchTreatments() async {
    try {
      final url = Uri.parse('$baseUrl/api/treatments/');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) {
          return TreatmentModel(
            id: e['id'] ?? 0,
            disease: e['disease'] ?? '',
            treatmentMethod: e['treatment_method'] ?? '',
            additionalInfo: e['additional_info'] ?? '',
            isSynced: true,
          );
        }).toList();
      } else {
        throw Exception('Failed to fetch treatments (${res.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching treatments: $e');
    }
  }

  // ------------------------
  // 🔹 TREATMENT: GET BY ID
  // ------------------------
  Future<List<TreatmentModel>> getTreatmentById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/api/get-treatment/?id=$id');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) {
          return data.map((e) {
            return TreatmentModel(
              id: e['id'] ?? 0,
              disease: e['disease'] ?? '',
              treatmentMethod: e['treatment_method'] ?? '',
              additionalInfo: e['additional_info'] ?? '',
              isSynced: true,
            );
          }).toList();
        } else if (data is Map) {
          return [
            TreatmentModel(
              id: data['id'] ?? 0,
              disease: data['disease'] ?? '',
              treatmentMethod: data['treatment_method'] ?? '',
              additionalInfo: data['additional_info'] ?? '',
              isSynced: true,
            ),
          ];
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to get treatment (${res.statusCode})');
      }
    } catch (e) {
      throw Exception('Error getting treatment: $e');
    }
  }

  // ------------------------
  // 🔹 USER STATS
  // ------------------------
  Future<List<UserStatsModel>> fetchUserStats() async {
    try {
      final url = Uri.parse('$baseUrl/api/user-stats/');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final List<UserStatsModel> stats = [];

        if (data['by_country'] != null) {
          for (var c in data['by_country']) {
            stats.add(
              UserStatsModel(
                country: c['country'] ?? '',
                totalByCountry: c['total'] ?? 0,
                county: '',
                totalByCounty: 0,
                isSynced: true,
              ),
            );
          }
        }

        if (data['by_county'] != null) {
          for (var c in data['by_county']) {
            stats.add(
              UserStatsModel(
                country: '',
                totalByCountry: 0,
                county: c['county'] ?? '',
                totalByCounty: c['total'] ?? 0,
                isSynced: true,
              ),
            );
          }
        }

        return stats;
      } else {
        throw Exception('Failed to fetch user stats (${res.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching user stats: $e');
    }
  }

  // ------------------------
  // 🔹 SAMPLE IMAGES
  // ------------------------
  Future<List<Map<String, String>>> fetchSampleImages() async {
    try {
      final url = Uri.parse('$baseUrl/api/sample-images/');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['images'] is List) {
          return (data['images'] as List)
              .map(
                (e) => {
                  'name': e['name']?.toString() ?? '',
                  'url': e['url']?.toString() ?? '',
                },
              )
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to fetch sample images (${res.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching sample images: $e');
    }
  }

  // ------------------------
  // 🔹 SYNC METHODS
  // ------------------------
  Future<bool> syncUser(UserModel user) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/users/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "country": user.country,
        "county": user.county,
      }),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<bool> syncCrop(CropModel crop) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/crops/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": crop.id,
        "cropname": crop.cropname,
        "description": crop.description,
      }),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<bool> syncDisease(DiseaseModel disease) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/diseases/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "disease_id": disease.diseaseId,
        "disease_name": disease.diseaseName,
        "crop": disease.crop,
        "description": disease.description,
      }),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<bool> syncTreatment(TreatmentModel t) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/treatments/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": t.id,
        "disease": t.disease,
        "treatment_method": t.treatmentMethod,
        "additional_info": t.additionalInfo,
      }),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  // ------------------------
  // 🔹 CHECK ONLINE
  // ------------------------
  Future<bool> checkOnline() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/treatments/'))
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
