import 'package:dio/dio.dart';
import 'package:todolistv2/export.dart';

class UserRepository {
  Dio dio = new Dio();
  Response response;
  String uri = "https://api-todo.mdcnugroho.xyz/api/user";

  Future<UserModel> login({UserModel model}) async {
    try {
      FormData datas =
          FormData.fromMap({'email': model.email, 'password': model.password});
      response = await dio.post(uri + "/login",
          data: datas,
          options: Options(headers: {"Accept": "application/json"}));
      var models = response.data;
      UserModel userModel = UserModel.fromJson(models);
      return userModel;
    } catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        if (e.response.statusCode == 401) {
          throw Exception("User not found");
        }
      }
      throw Exception(e);
    }
  }

  Future<int> registrasi({UserModel model}) async {
    try {
      FormData datas = FormData.fromMap({
        'name': model.name,
        'password': model.password,
        'email': model.email
      });
      response = await dio.post(uri,
          data: datas,
          options: Options(headers: {"Accept": "application/json"}));

      return response.statusCode;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> update({int id, UserModel model}) async {
    try {
      FormData formData = FormData.fromMap({
        "_method": "PUT",
        "name": model.name,
        "email": model.email,
        "password": model.password
      });
      response = await dio.post(uri + "/$id", data: formData);
      return response.statusCode;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> delete({int id}) async {
    try {
      response = await dio.delete(uri + "/$id");
      return response.statusCode;
    } catch (e) {
      throw Exception(e);
    }
  }
}
