import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'base_resp.dart';

/**
 * 参考如下：
 * @Author: thl
 * @GitHub: https://github.com/Sky24n
 * @JianShu: https://www.jianshu.com/u/cbf2ad25d33a
 * @Email: 863764940@qq.com
 * @Description: Dio Util.
 * @Date: 2018/12/19
 * https://www.jianshu.com/p/02907d4ae438
 * https://github.com/Sky24n/FlutterRepos/blob/master/base_library/lib/src/data/net/dio_util.dart
 */

/// 请求方法.
class Method {
  static const String get = "GET";
  static const String post = "POST";
  static const String put = "PUT";
  static const String head = "HEAD";
  static const String delete = "DELETE";
  static const String patch = "PATCH";
}

///Http配置.
class HttpConfig {
  /// constructor.
  HttpConfig({
    this.status,
    this.code,
    this.msg,
    this.data,
    this.options,
    this.pem,
    this.pKCSPath,
    this.pKCSPwd,
  });

  /// BaseResp [String status]字段 key, 默认：status.
  String? status;

  /// BaseResp [int code]字段 key, 默认：errorCode.
  String? code;

  /// BaseResp [String msg]字段 key, 默认：errorMsg.
  String? msg;

  /// BaseResp [T data]字段 key, 默认：data.
  String? data;

  /// Options.
  Options? options;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PEM证书内容.
  String? pem;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PKCS12 证书路径.
  String? pKCSPath;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PKCS12 证书密码.
  String? pKCSPwd;
}

/// 单例 DioUtil.
/// debug模式下可以打印请求日志. DioUtil.openDebug().
/// dio详细使用请查看dio官网(https://github.com/flutterchina/dio).
class DioUtil {
  static final DioUtil _singleton = DioUtil._init();
  static late Dio _dio;

  /// BaseResp [String status]字段 key, 默认：status.
  final String _statusKey = "status";

  /// BaseResp [int code]字段 key, 默认：errorCode.
  final String _codeKey = "errorCode";

  /// BaseResp [String msg]字段 key, 默认：errorMsg.
  final String _msgKey = "errorMsg";

  /// BaseResp [T data]字段 key, 默认：data.
  final String _dataKey = "data";

  /// Options.
  final BaseOptions? _options = getDefOptions();

  // /// PEM证书内容.
  // String _pem;

  // /// PKCS12 证书路径.
  // String _pKCSPath;

  // /// PKCS12 证书密码.
  // String _pKCSPwd;

  /// 是否是debug模式.
  static bool _isDebug = true;

  static DioUtil getInstance() {
    return _singleton;
  }

  factory DioUtil() {
    return _singleton;
  }

  DioUtil._init() {
    _dio = Dio(_options);
    // _dio.interceptors.add(ConnectsInterceptor());
  }

  /// 打开debug模式.
  static void openDebug() {
    _isDebug = true;
  }

  void setCookie(String cookie) {
    Map<String, dynamic> headers = {};
    headers["Cookie"] = cookie;
    _dio.options.headers.addAll(headers);
  }

  /// set Config.
  // void setConfig(HttpConfig config) {
  //   _statusKey = config.status ?? _statusKey;
  //   _codeKey = config.code ?? _codeKey;
  //   _msgKey = config.msg ?? _msgKey;
  //   _dataKey = config.data ?? _dataKey;
  //   _mergeOption(config.options);
  //   _pem = config.pem ?? _pem;
  //   if (_dio != null) {
  //     _dio.options = _options;
  //     if (_pem != null) {
  //       _dio.onHttpClientCreate = (HttpClient client) {
  //         client.badCertificateCallback =
  //             (X509Certificate cert, String host, int port) {
  //           if (cert.pem == _pem) {
  //             // 证书一致，则放行
  //             return true;
  //           }
  //           return false;
  //         };
  //       };
  //     }
  //     if (_pKCSPath != null) {
  //       _dio.onHttpClientCreate = (HttpClient client) {
  //         SecurityContext sc = new SecurityContext();
  //         //file为证书路径
  //         sc.setTrustedCertificates(_pKCSPath, password: _pKCSPwd);
  //         HttpClient httpClient = new HttpClient(context: sc);
  //         return httpClient;
  //       };
  //     }
  //   }
  // }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseRespR<T> 返回  code msg data Response.
  Future<BaseRes<T>> requestRes<T>(String method, String path,
      {data, Options? options, CancelToken? cancelToken}) async {
    _printPreviousHttpLog(path);
    Response response =
        await _dio.request(path, data: data, options: _checkOptions(method, options), cancelToken: cancelToken);
    _printHttpLog(response);
    int code;
    String msg;
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      try {
        code = (response.data[_codeKey] is String) ? int.tryParse(response.data[_codeKey]) : response.data[_codeKey];
        msg = response.data[_msgKey];
        return BaseRes(code, msg, response.data, response);
      } catch (e) {
        return Future.error(response.data[_msgKey]);
      }
    }
    return Future.error("解析错误");
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseResp<T> 返回 status code msg data .
  Future<BaseResp<T>> request<T>(String method, String path, {data, Options? options, CancelToken? cancelToken}) async {
    Response response =
        await _dio.request(path, data: data, options: _checkOptions(method, options), cancelToken: cancelToken);
    _printHttpLog(response);
    String status;
    int code;
    String msg;
    T data0;
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          status =
              (response.data[_statusKey] is int) ? response.data[_statusKey].toString() : response.data[_statusKey];
          code = (response.data[_codeKey] is String) ? int.tryParse(response.data[_codeKey]) : response.data[_codeKey];
          msg = response.data[_msgKey];
          data0 = response.data[_dataKey];
        } else {
          Map<String, dynamic> dataMap = _decodeData(response);
          status = (dataMap[_statusKey] is int) ? dataMap[_statusKey].toString() : dataMap[_statusKey];
          code = (dataMap[_codeKey] is String) ? int.tryParse(dataMap[_codeKey]) : dataMap[_codeKey];
          msg = dataMap[_msgKey];
          data0 = (dataMap.containsKey(_dataKey)) ? dataMap[_dataKey] : dataMap;
        }
        return BaseResp(status, code, msg, data0);
      } catch (e) {
        return Future.error(response.data[_msgKey]);
      }
    }
    return Future.error("解析错误");
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseRespR<T> 返回 status code msg data  Response.
  Future<BaseRespR<T>> requestR<T>(String method, String path,
      {data, Options? options, CancelToken? cancelToken}) async {
    _printPreviousHttpLog(path);
    Response response =
        await _dio.request(path, data: data, options: _checkOptions(method, options), cancelToken: cancelToken);
    _printHttpLog(response);
    String status;
    int code;
    String msg;
    T data0;
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          status =
              (response.data[_statusKey] is int) ? response.data[_statusKey].toString() : response.data[_statusKey];
          code = (response.data[_codeKey] is String) ? int.tryParse(response.data[_codeKey]) : response.data[_codeKey];
          msg = response.data[_msgKey];
          data0 = response.data[_dataKey];
        } else {
          Map<String, dynamic> dataMap = _decodeData(response);
          status = (dataMap[_statusKey] is int) ? dataMap[_statusKey].toString() : dataMap[_statusKey];
          code = (dataMap[_codeKey] is String) ? int.tryParse(dataMap[_codeKey]) : dataMap[_codeKey];
          msg = dataMap[_msgKey];
          data0 = (dataMap.containsKey(_dataKey)) ? dataMap[_dataKey] : dataMap;
        }
        return BaseRespR(status, code, msg, data0, response);
      } catch (e) {
        return Future.error(response.data[_msgKey]);
      }
    }
    return Future.error("解析错误");
  }

  /// Download the file and save it in local. The default http method is "GET",you can custom it by [Options.method].
  /// [urlPath]: The file url.
  /// [savePath]: The path to save the downloading file later.
  /// [onProgress]: The callback to listen downloading progress.please refer to [OnDownloadProgress].
  Future<Response> download(
    String urlPath,
    savePath, {
    // OnDownloadProgress onProgress,
    CancelToken? cancelToken,
    data,
    Options? options,
  }) {
    return _dio.download(urlPath, savePath,
        // onProgress: onProgress,
        cancelToken: cancelToken,
        data: data,
        options: options);
  }

  /// decode response data.
  Map<String, dynamic> _decodeData(Response response) {
    if (response.data == null || response.data.toString().isEmpty) {
      return {};
    }
    return json.decode(response.data.toString());
  }

  /// check Options.
  Options _checkOptions(method, options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  // /// merge Option.
  // void _mergeOption(Options opt) {
  //   _options.method = opt.method ?? _options.method;
  //   _options.headers = (new Map.from(_options.headers))..addAll(opt.headers);
  //   _options.baseUrl = opt.baseUrl ?? _options.baseUrl;
  //   _options.connectTimeout = opt.connectTimeout ?? _options.connectTimeout;
  //   _options.receiveTimeout = opt.receiveTimeout ?? _options.receiveTimeout;
  //   _options.responseType = opt.responseType ?? _options.responseType;
  //   _options.data = opt.data ?? _options.data;
  //   _options.extra = (new Map.from(_options.extra))..addAll(opt.extra);
  //   _options.contentType = opt.contentType ?? _options.contentType;
  //   _options.validateStatus = opt.validateStatus ?? _options.validateStatus;
  //   _options.followRedirects = opt.followRedirects ?? _options.followRedirects;
  // }

  /// print Http Log.
  void _printPreviousHttpLog(String path) {
    if (!_isDebug) {
      return;
    }
    print("----------------Http Log----------------"
        "\n[path   ]:   $path");
  }

  /// print Http Log.
  void _printHttpLog(Response response) {
    if (!_isDebug) {
      return;
    }
    try {
      print(
          // "----------------Http Log----------------\n"
          "[statusCode]:   ${response.statusCode}"
          "\n[request   ]:   ${_getOptionsStr(response.requestOptions)}");
      _printDataStr("reqdata ", response.requestOptions.data);
      _printDataStr("response", response.data);
    } catch (ex) {
      print("Http Log" " error......");
    }
  }

  /// get Options Str.
  String _getOptionsStr(RequestOptions request) {
    return "method: ${request.method}  baseUrl: ${request.baseUrl}  path: ${request.path}";
  }

  /// print Data Str.
  void _printDataStr(String tag, Object value) {
    String da = value.toString();
    while (da.isNotEmpty) {
      if (da.length > 512) {
        print("[$tag  ]:   ${da.substring(0, 512)}");
        da = da.substring(512, da.length);
      } else {
        print("[$tag  ]:   $da");
        da = "";
      }
    }
  }

  /// get dio.
  Dio getDio() {
    return _dio;
  }

  /// create new dio.
  static Dio createNewDio([BaseOptions? options]) {
    options = options ?? getDefOptions();
    Dio dio = Dio(options);
    return dio;
  }

  /// get Def Options.
  static BaseOptions? getDefOptions() {
    BaseOptions options = BaseOptions();
    options.contentType = "application/x-www-form-urlencoded";
    options.connectTimeout = const Duration(seconds: 30);
    options.receiveTimeout = const Duration(seconds: 30);
    return options;
  }
}
