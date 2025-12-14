import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  static String? token;

  static Map<String, String> get headers {
    return {
      "Content-Type": "application/json",
      if (token != null)
        "Authorization": "Bearer $token", // may be only "$token"
    };
  }

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login/"),
      headers: const {"Content-Type": "application/x-www-form-urlencoded"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      token = jsonDecode(response.body)["access_token"];
      return true;
    }
    return false;
  }

  static Future<List<dynamic>> getUserPlans() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user/plans"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to load plans: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error loading plans: $e");
      return [];
    }
  }

  static Future<bool> subscribeToPlan(int planId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/plans/$planId/subscribe"),
      headers: headers,
    );

    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getTrainerPlans() async {
    final response = await http.get(
      Uri.parse("$baseUrl/trainer/plans"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<bool> createPlan(
    String title,
    String description,
    double price,
    int durationDays,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/trainer/plans"),
      headers: headers,
      body: jsonEncode({
        "title": title,
        "p_description": description,
        "price": price,
        "duration_days": durationDays,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deletePlan(int planId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/trainer/plans/$planId"),
      headers: headers,
    );

    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getUserFeed() async {
    final response = await http.get(
      Uri.parse("$baseUrl/user/feed"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map && decoded.containsKey("data")) {
        return decoded["data"];
      }

      if (decoded is List) {
        return decoded;
      }
    }
    return [];
  }
}
