import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';
import '../model/register_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    String url = "https://www.getpostman.com/collections/299632c9a18ed457ba78";

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<RegisterResponseModel> register(RegisterRequestModel requestModel) async {
    String url = "https://reqres.in/api/register";

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegisterResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }


}
