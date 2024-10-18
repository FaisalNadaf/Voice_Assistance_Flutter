import 'package:http/http.dart' as http;
import 'dart:convert';

class LLaMAApiService {
  final String apiUrl = 'http://192.168.1.8:5000/generate';

  Future<String> getLLaMAResponse(String inputText) async {
    try {
      // Prepare the request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"input": inputText}),
      );

      // Check the response status
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['response'] ?? 'No response from LLaMA';
      } else {
        // Log the error response for debugging
        print('Error: ${response.statusCode} - ${response.body}');
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      // Print the error for debugging
      print("Error getting LLaMA response: $e");
      return "Error fetching response from LLaMA: $e";
    }
  }
}
