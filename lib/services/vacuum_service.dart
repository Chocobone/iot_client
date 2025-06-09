import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vacuum_status.dart';

class VacuumService {
  static const String baseUrl = 'http://192.168.35.145:18000';

  // 서버 상태 체크
  Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 로봇청소기 상태 가져오기
  Future<VacuumStatus?> getVacuumStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vacuum/status'));
      if (response.statusCode == 200) {
        return VacuumStatus.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 청소 시작
  Future<bool> startVacuum() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/vacuum/start'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 청소 일시정지
  Future<bool> pauseVacuum() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/vacuum/pause'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 충전기로 귀환
  Future<bool> returnToDock() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/vacuum/return'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
