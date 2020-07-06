import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolistv2/bloc/user/user_bloc.dart';
import 'package:todolistv2/export.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserBloc _userBloc;
  String _email, _password;

  _loadSession({String name, String token, String id}) async {
    SharedPreferences _p = await SharedPreferences.getInstance();
    setState(() {
      _p.setString("token", token);
      _p.setString("name", name);
      _p.setString("id", id);
    });
  }

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width * (2 / 5),
                width: double.infinity,
                color: Colors.amber,
                child: Center(
                  child: Text(
                    "Login Screen",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          onSaved: (newValue) {
                            _email = newValue;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            if (!EmailValidator.validate(value)) {
                              return "Format email salah";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(hintText: "Alamat Email"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          onSaved: (newValue) {
                            _password = newValue;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          ),
                          color: Colors.amber,
                          onPressed: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              UserModel model =
                                  UserModel(email: _email, password: _password);
                              _userBloc.add(UserLogin(model: model));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => RegistrationScreen()));
                          },
                          child: Text("Registrasi"),
                        ),
                      ),
                      BlocConsumer<UserBloc, UserState>(
                        listener: (context, state) {
                          if (state is UserLoginSuccess) {
                            _loadSession(
                                id: state.model.id.toString(),
                                name: state.model.name,
                                token: state.model.apiToken);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PostAllScreen(
                                          model: state.model,
                                        )));
                          }
                        },
                        builder: (context, state) {
                          if (state is UserWaiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is UserError) {
                            return Center(
                              child: Text(state.messege),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
