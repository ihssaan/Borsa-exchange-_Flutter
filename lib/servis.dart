import 'package:dio/dio.dart';
import 'model.dart';

class BorsamService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.collectapi.com/economy/hisseSenedi",
      headers: {
        'content-type': 'application/json',
        'authorization': 'KENDİ APİ KEYİNİZ',
      },
    ),
  );

  // Hisse senedi verisini almak için fonksiyon
  Future<Borsam?> fetchBorsamData() async {
    try {
      final response = await _dio.get('/hisseSenedi');

      // Yanıt başarılıysa veriyi Borsam modeline dönüştür
      if (response.statusCode == 200) {
        return Borsam.fromJson(response.data);
      } else {
        print('Hata: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }
}
