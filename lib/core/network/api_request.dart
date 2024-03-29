import 'package:MSG/constant/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future postResquest({
  @required String url,
  Map headers,
  @required dynamic body,
  Map queryParam,
}) async {
  Dio dio = Dio();
  String route = BasedUrl + url;
  dio.options.contentType = Headers.formUrlEncodedContentType;
  Response response = await dio.post(
    route,
    data: body,
    queryParameters: queryParam,
    options: Options(
      headers: headers,
    ),
  );
  return response;
}

Future postFormResquest({
  @required String url,
  Map headers,
  @required dynamic body,
  Map queryParam,
}) async {
  final dio = Dio();
  String route = BasedUrl + url;
  dio.options.contentType = Headers.formUrlEncodedContentType;
  Response response = await dio.post(
    route,
    data: body,
    queryParameters: queryParam,
    options: Options(
      headers: headers,
    ),
  );
  return response;
}

Future getRequest({
  @required String url,
  Map headers,
  Map queryParam,
}) async {
  Dio dio = Dio();
  String route = BasedUrl + url;
  dio.options.contentType = Headers.formUrlEncodedContentType;
  Response response = await dio.get(
    route,
    queryParameters: queryParam,
    options: Options(
      headers: headers,
    ),
  );
  return response;
}

Future patchResquest({
  @required String url,
  Map headers,
  @required dynamic body,
  Map queryParam,
}) async {
  Dio dio = Dio();
  String route = BasedUrl + url;
  dio.options.contentType = Headers.formUrlEncodedContentType;
  Response response = await dio.patch(
    route,
    data: body,
    queryParameters: queryParam,
    options: Options(
      headers: headers,
    ),
  );
  return response;
}
