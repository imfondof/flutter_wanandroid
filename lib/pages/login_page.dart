import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../common/common_index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  Artboard? _riveArtboard;

  SMIInput<bool>? _success;
  SMIInput<bool>? _fail;
  SMIInput<bool>? _check;
  SMIInput<bool>? _handUp;
  SMIInput<double>? _look;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _psdController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _psdFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/anim/login_screen_character.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);
          _check = controller.findInput('Check');
          _look = controller.findInput('Look');
          _success = controller.findInput('success');
          _fail = controller.findInput('fail');
          _handUp = controller.findInput('hands_up');
        }
        setState(() => _riveArtboard = artboard);
      },
    );

    _userNameController.addListener(() {
      toLook();
    });

    _userNameFocusNode.addListener(() {
      if (_userNameFocusNode.hasFocus) {
        toLook();
      } else {
        cancelLook();
      }
    });

    _psdFocusNode.addListener(() {
      if (_psdFocusNode.hasFocus) {
        handUp();
      } else {
        cancelHandUp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffd6e2ea),
              // borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  color: Colors.transparent,
                  height: 200,
                  width: 200,
                  child: _riveArtboard == null
                      ? const SizedBox()
                      : GestureDetector(
                          child: Column(
                            children: [
                              Expanded(
                                child: Rive(artboard: _riveArtboard!),
                              ),
                            ],
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 2, 50, 2),
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
                  padding: const EdgeInsets.fromLTRB(50, 2, 50, 2),
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
                InkWell(
                  onTap: () {
                    String username = _userNameController.text;
                    String password = _psdController.text;
                    _login(username, password);
                    setState(() {
                      _login(username, password);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 50, right: 50, top: 30),
                    width: 260,
                    height: 45,
                    decoration: const BoxDecoration(
                      color: Color(0xffa8cae1),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: const Center(child: Text("登录")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _login(String username, String password) async {
    if ((username.isNotEmpty) && (password.isNotEmpty)) {
      _showLoading(context);
      wanRepository.login(username, password).then((UserModel userModel) {
        _dismissLoading(context);
        loginSuccess();
        Log.i("success : ${userModel.toString()}");
      }).catchError((error) {
        loginFailed();
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

  void toLook() {
    setState(() {
      _check?.value = true;
      _look?.value = double.parse("${_userNameController.text.length * 3}");
    });
  }

  void cancelLook() {
    setState(() {
      _check?.value = false;
    });
  }

  void loginSuccess() {
    setState(() {
      _success?.value = true;
    });
  }

  void loginFailed() {
    setState(() {
      _fail?.value = true;
    });
  }

  void handUp() {
    setState(() {
      _handUp?.value = true;
    });
  }

  void cancelHandUp() {
    setState(() {
      _handUp?.value = false;
    });
  }

  void playIdle() {
    setState(() {
      // _idleController.isActive = true;
    });
  }
}
