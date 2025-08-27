import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_project_sanbercode/app/data/services/api_keys.dart';

class AIService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';

  static Future<String> generateText(String prompt) async {
    try {
      final url = Uri.parse('$_baseUrl?key=${geminiApiKey}');
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final generatedText =
            data['candidates'][0]['content']['parts'][0]['text'];
        
        final cleanedText = generatedText
            .replaceAll(RegExp(r'\*\*|__'), '') // Hapus bold (**text** atau __text__)
            .replaceAll(RegExp(r'\*|_'), '')   // Hapus italic (*text* atau _text_)
            .replaceAll(RegExp(r'#+\s'), '')    // Hapus heading (## Heading)
            .replaceAll(RegExp(r'^\s*-\s*', multiLine: true), '') // Hapus tanda '-' di awal baris
            .trim();

        return cleanedText;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Failed to generate text: ${errorData['error']['message']}');
      }
    } catch (e) {
      print('Error in AIService: $e');
      return 'Maaf, terjadi kesalahan saat menghubungi AI.';
    }
  }
}
