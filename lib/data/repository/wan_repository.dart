import 'package:flutter_wanandroid/common/common_index.dart';
import 'package:flutter_wanandroid/data/apis.dart';

import '../../common/config.dart';
import '../../models/user_model.dart';
import '../base_resp.dart';
import '../constant.dart';
import '../dio_util.dart';

WanRepository _wanRepository = WanRepository();

WanRepository get wanRepository => _wanRepository;

class WanRepository {
  Future<UserModel> login(String username, String password) async {
    BaseRes<Map<String, dynamic>> baseResp = await DioUtil()
        .requestRes<Map<String, dynamic>>(Method.post, Apis.login, data: {"username": username, "password": password});
    if (baseResp.code != Constants.statusSuccess) {
      return Future.error(baseResp.msg);
    }
    baseResp.response.headers.forEach((String name, List<String> values) {
      if (name == "set-cookie") {
        String cookie = values.toString();
        Log.i("set-cookie: $cookie");
        SPUtil.putString(Constant.keyAppCookie, cookie);
        DioUtil().setCookie(cookie);
        //CacheUtil().setLogin(true);
      }
    });
    UserModel model = UserModel.fromJson(baseResp.data);
    //CacheUtil().setUserModel(model);
    // SpUtil.putObject(BaseConstant.keyUserModel, model);
    return model;
  }
}
