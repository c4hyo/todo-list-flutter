import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolistv2/export.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(
          create: (context) => PostBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'TO-DO LIST',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.amber,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.ptSansTextTheme()),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _token, _id, _nama;
  _cekSession() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _token = _pref.getString("token") ?? null;
      _id = _pref.getString("id") ?? null;
      _nama = _pref.getString("name") ?? null;
    });
  }

  @override
  void initState() {
    _cekSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amberAccent[50],
        body: SafeArea(
          child: _token == null
              ? LoginScreen()
              : PostAllScreen(
                  model: UserModel(
                      apiToken: _token, id: int.parse(_id), name: _nama),
                ),
        ));
  }
}
