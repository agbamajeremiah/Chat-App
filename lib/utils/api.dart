import 'package:MSG/constant/base_url.dart';
import 'package:MSG/interceptors/dio_connectivity_request_retrier.dart';
import 'package:MSG/interceptors/retry_request_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';

Future postResquest({
  @required String url,
  Map headers,
  @required dynamic body,
  Map queryParam,
}) async {
  final dio = Dio();
  String route = BasedUrl + url;
  dio.interceptors.add(
    RetryOnConnectionChangeInterceptor(
      requestRetrier: DioConnectivityRequestRetrier(
        dio: Dio(),
        connectivity: Connectivity(),
      ),
    ),
  );
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
