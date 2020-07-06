import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolistv2/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostAllScreen extends StatefulWidget {
  final UserModel model;
  PostAllScreen({this.model});
  @override
  _PostAllScreenState createState() => _PostAllScreenState();
}

class _PostAllScreenState extends State<PostAllScreen> {
  PostBloc _postBloc;
  List<PostModel> post = [];
  List<PostModel> cari = [];

  _removeSession() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _pref.remove("token");
      _pref.remove("id");
      _pref.remove("name");
    });
  }

  _dialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Sign Out"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Yes"),
                onPressed: () {
                  _removeSession();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
              ),
              SimpleDialogOption(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    _postBloc = BlocProvider.of<PostBloc>(context);
    _postBloc.add(PostIndex(token: widget.model.apiToken));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Post"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesome.plus_square_o),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PostAddScreen(
                            model: widget.model,
                          ))))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text("${widget.model.name}"),
                accountEmail: Text("")),
            Expanded(
              child: SizedBox.shrink(),
            ),
            ListTile(
              title: Text("Sign out"),
              trailing: Icon(FontAwesome.sign_out),
              onTap: () {
                _dialog();
              },
            )
          ],
        ),
      ),
      body: Center(
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostWaiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is PostLoaded) {
              post = state.model;
              return post.length == 0
                  ? Center(
                      child: Text(
                        "You dont have a post",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: post.length,
                        itemBuilder: (context, index) {
                          final data = post[index];
                          return Card(
                            child: ExpansionTile(
                              title: Text(
                                "${data.title}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 27),
                              ),
                              leading: Icon(
                                Ionicons.ios_checkbox,
                                color: (data.pinned == "0")
                                    ? Colors.grey
                                    : Colors.amber,
                              ),
                              subtitle: Text("${data.createdAt}"),
                              trailing: IconButton(
                                  icon: Icon(FontAwesome.edit),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PostEditScreen(
                                                  model: widget.model,
                                                  post: data,
                                                ),
                                            fullscreenDialog: true));
                                  }),
                              children: <Widget>[
                                Divider(
                                  color: Colors.amber,
                                  thickness: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "${data.description}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
