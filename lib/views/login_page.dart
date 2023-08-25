import 'package:flutter/material.dart';
import '../common/common_index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _psdController = TextEditingController();

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _psdFocusNode = FocusNode();

  @override
  void initState() {
    // Configure keyboard actions
    // FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0.4,
            title: const Text("登录"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "用户登录",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "请使用WanAndroid账号登录",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    child: TextField(
                      focusNode: _userNameFocusNode,
                      autofocus: false,
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        labelText: "用户名",
                        hintText: "请输入用户名",
                        labelStyle: TextStyle(color: Colors.cyan),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    child: TextField(
                      focusNode: _psdFocusNode,
                      controller: _psdController,
                      decoration: const InputDecoration(
                        labelText: "密码",
                        labelStyle: TextStyle(color: Colors.cyan),
                        hintText: "请输入密码",
                      ),
                      obscureText: true,
                      maxLines: 1,
                    ),
                  ),

                  // 登录按钮
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            // padding: EdgeInsets.all(16.0),
                            // elevation: 0.5,
                            child: const Text("登录"),
                            // color: Theme.of(context).primaryColor,
                            // textColor: Colors.white,
                            onPressed: () {
                              String username = _userNameController.text;
                              String password = _psdController.text;
                              _login(username, password);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    // child: FlatButton(
                    //   child: Text("还没有账号，注册一个？", style: TextStyle(fontSize: 14)),
                    //   onPressed: () {
                    //     registerClick();
                    //   },
                    // )
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future _login(String username, String password) async {
    if ((username.isNotEmpty) && (password.isNotEmpty)) {
      _showLoading(context);
      wanRepository.login(username, password).then((UserModel userModel) {
        _dismissLoading(context);
        Log.i(userModel.toString());
      }).catchError((error) {
        Log.i(error.toString());
        _dismissLoading(context);
      });
    } else {
      // T.show(msg: "用户名或密码不能为空");
    }
  }

  /// 显示Loading
  _showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return LoadingDialog(
            outsideDismiss: false,
            loadingText: "正在登陆...",
          );
        });
  }

  /// 隐藏Loading
  _dismissLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

// void registerClick() async {
//   await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
//     return new RegisterScreen();
//   })).then((value) {
//     var map = jsonDecode(value);
//     var username = map['username'];
//     var password = map['password'];
//     _userNameController.text = username;
//     _psdController.text = password;
//     _login(username, password);
//   });
// }
}
