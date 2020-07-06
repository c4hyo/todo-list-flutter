import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolistv2/export.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserBloc _userBloc;
  String _email, _password, _name;

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
                    "Registration Screen",
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
                            _name = newValue;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: "Name"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          onSaved: (newValue) {
                            _email = newValue;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email is required";
                            }
                            if (!EmailValidator.validate(value)) {
                              return "Invalid email format";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(hintText: "Email"),
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
                            _key.currentState.save();
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password is required";
                            }
                            if (value != _password) {
                              return "Password doesnt match";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration:
                              InputDecoration(hintText: "Confirm Password"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          child: Text(
                            "Register Now",
                            style: TextStyle(fontSize: 20),
                          ),
                          color: Colors.amber,
                          onPressed: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              UserModel model = UserModel(
                                  email: _email,
                                  password: _password,
                                  name: _name);
                              _userBloc.add(UserRegistration(model: model));
                            }
                          },
                        ),
                      ),
                      BlocConsumer<UserBloc, UserState>(
                        listener: (context, state) {
                          if (state is UserSuccess) {
                            Navigator.pop(context);
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
