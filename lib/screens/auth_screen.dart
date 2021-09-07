import 'package:flutter/material.dart';
import 'package:news_app/screens/home_screen.dart';
import '../Configration/Config.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../model/httpExceptionApi.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  static final routeName = 'auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/paper1.jpg'), fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1, child: AuthCard()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authMap = {
    Config.authEmail: '',
    Config.authPassword: '',
    Config.userName: '',
    Config.phoneNumber: '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.SignUp) {
        await Provider.of<Auth>(context, listen: false).signUp(
            _authMap[Config.authEmail],
            _authMap[Config.authPassword],
            _authMap[Config.userName],
            _authMap[Config.phoneNumber]);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .login(_authMap[Config.authEmail], _authMap[Config.authPassword])
            .then((value) => {
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.routeName)
                });
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on HttpException catch (e) {
      setState(() {
        _isLoading = false;
      });
      this._showErrorDialog(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      color: Color.fromRGBO(230, 240, 233, 0.8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 420 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 420 : 260,
        ),
        width: deviceSize.width * 0.8,
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email ",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains("@")) {
                      return "Invalid Email";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _authMap[Config.authEmail] = newValue;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return "Password is too short";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) =>
                      _authMap[Config.authPassword] = newValue,
                ),
                SizedBox(
                  height: 10,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 100 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 130 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              enabled: _authMode == AuthMode.SignUp,
                              decoration: InputDecoration(
                                hintText: "Confim Password",
                              ),
                              obscureText: true,
                              validator: _authMode == AuthMode.SignUp
                                  ? (val) {
                                      if (val != _passwordController.text) {
                                        return "Password do not match";
                                      }
                                      return null;
                                    }
                                  : null,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              enabled: _authMode == AuthMode.SignUp,
                              decoration: InputDecoration(
                                hintText: "Username",
                              ),
                              obscureText: false,
                              validator: _authMode == AuthMode.SignUp
                                  ? (val) {
                                      if (val.isEmpty) {
                                        return "Username is empty !";
                                      }
                                      return null;
                                    }
                                  : null,
                              onSaved: (newValue) =>
                                  _authMap[Config.userName] = newValue,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              enabled: _authMode == AuthMode.SignUp,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                              ),
                              obscureText: false,
                              validator: _authMode == AuthMode.SignUp
                                  ? (val) {
                                      if (val.isEmpty) {
                                        return "Phone number is empty!";
                                      }
                                      return null;
                                    }
                                  : null,
                              onSaved: (newValue) =>
                                  _authMap[Config.phoneNumber] = newValue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (_isLoading) CircularProgressIndicator(),
                RaisedButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text(
                    _authMode == AuthMode.Login ? "Login" : "SignUp",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                FlatButton(
                  child: Text(_authMode == AuthMode.Login
                      ? "Sign Up Inseted"
                      : "Login Inseted"),
                  onPressed: () {
                    if (_authMode == AuthMode.Login) {
                      setState(() {
                        _authMode = AuthMode.SignUp;
                      });
                      _controller.forward();
                    } else {
                      setState(() {
                        _authMode = AuthMode.Login;
                      });
                      _controller.reverse();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    setState(() {
      _isLoading = false;
    });
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("An Error Occurred ! "),
            content: Text(errorMessage),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay !")),
            ],
          );
        });
  }
}
