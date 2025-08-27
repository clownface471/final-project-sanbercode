// Impor package yang dibutuhkan untuk melakukan HTTP request.
import 'dart:convert';
import 'package:http/http.dart' as http;

// Impor file yang berisi API Key kita.
// Ini adalah praktik yang baik untuk memisahkan kunci dari logika.
import 'package:final_project_sanbercode/app/data/services/api_keys.dart';

class AIService {
  // Ini adalah 'alamat' dari server Google AI (Gemini).
  // Kita akan mengirim permintaan ke alamat ini.
  // 'generateContent' adalah bagian spesifik dari API yang kita tuju.
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';

  /// Fungsi utama untuk berinteraksi dengan Gemini AI.
  /// Menerima sebuah [prompt] (perintah dalam bentuk teks) dan
  /// akan mengembalikan hasil teks yang digenerate oleh AI.
  ///
  /// Cara kerja untuk tim:
  /// - Person 3 (Integrator): Kamu cukup panggil fungsi ini dari controller,
  ///   misalnya `AIService.generateText("Ringkas teks ini: ...")`.
  /// - Kamu tidak perlu tahu detail cara kerjanya, cukup berikan perintah
  ///   dan tunggu hasilnya.
  static Future<String> generateText(String prompt) async {
    try {
      // Kita membuat URL lengkap dengan menyertakan API key.
      final url = Uri.parse('$_baseUrl?key=${geminiApiKey}');

      // Ini adalah 'surat' yang akan kita kirim ke server.
      // Isinya adalah prompt dari pengguna, dibungkus dalam format JSON
      // sesuai dengan yang diminta oleh dokumentasi Gemini API.
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      });

      // Mengirim permintaan ke server menggunakan metode POST.
      // Kita menyertakan 'headers' untuk memberitahu server bahwa kita mengirim data JSON.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Memeriksa apakah server merespons dengan sukses (kode 200).
      if (response.statusCode == 200) {
        // Jika sukses, kita 'bongkar' balasan JSON dari server.
        final data = jsonDecode(response.body);

        // Kita navigasi masuk ke dalam struktur JSON untuk mengambil teks hasil.
        // Berdasarkan dokumentasi Gemini, hasilnya ada di:
        // candidates -> [0] -> content -> parts -> [0] -> text
        final generatedText =
            data['candidates'][0]['content']['parts'][0]['text'];

        // Mengembalikan hasil teks yang sudah bersih.
        return generatedText.trim();
      } else {
        // Jika server memberikan error, kita lempar pesan error.
        // Ini akan ditangkap oleh 'catch' di bawah.
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Failed to generate text: ${errorData['error']['message']}');
      }
    } catch (e) {
      // Jika terjadi error apapun (misal: tidak ada internet),
      // kita cetak errornya dan kembalikan pesan yang jelas.
      print('Error in AIService: $e');
      return 'Maaf, terjadi kesalahan saat menghubungi AI.';
    }
  }
}
