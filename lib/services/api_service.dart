import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://devapiv4.dealsdray.com/api/v2/user';

  static Future<Map<String, dynamic>> requestOtp(String mobileNumber, String deviceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mobileNumber': mobileNumber,
        'deviceId': deviceId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to request OTP');
    }
  }

 static Future<Map<String, dynamic>> verifyOtp(String otp, String? deviceId, String userId) async {
  final response = await http.post(
    Uri.parse('$baseUrl/otp/verification'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'otp': otp,
      'deviceId': deviceId,
      'userId': userId,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to verify OTP');
  }
}
}