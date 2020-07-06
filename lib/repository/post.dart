import 'package:dio/dio.dart';
import 'package:todolistv2/export.dart';

class PostRepository {
  Dio dio = new Dio();
  Response response;
  String uri = "https://api-todo.mdcnugroho.xyz/api/post";

  Future<List<PostModel>> index({String token}) async {
    try {
      response = await dio.get(uri,
          options: Options(responseType: ResponseType.json, headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          }));
      List list = response.data;
      List<PostModel> postModel =
          list.map((e) => PostModel.fromJson(e)).toList();
      return postModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> create({String token, PostModel models}) async {
    try {
      FormData formData = FormData.fromMap(
          {"title": models.title, "description": models.description});
      response = await dio.post(uri,
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          }));
      return response.statusCode;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> update({String token, int id, PostModel models}) async {
    try {
      FormData formData = FormData.fromMap({
        "title": models.title,
        "description": models.description,
        "_method": "PUT"
      });
      response = await dio.post(uri + "/$id",
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          }));
      return response.statusCode;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> delete({String token, int id}) async {
    try {
      response = await dio.delete(uri + "/$id",
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          }));
      return response.statusCode;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> pin({String token, int id}) async {
    try {
      response = await dio.post(uri + "/$id/pin",
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          }));
      return response.statusCode;
    } catch (e) {
      throw Exception(e);
    }
  }
}
