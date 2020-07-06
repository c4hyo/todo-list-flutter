import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolistv2/export.dart';

class PostAddScreen extends StatefulWidget {
  final UserModel model;
  PostAddScreen({this.model});
  @override
  _PostAddScreenState createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _title, _description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Post"),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    BlocConsumer<PostBloc, PostState>(
                      listener: (context, state) {
                        if (state is PostLoaded) {
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is PostWaiting) {
                          return LinearProgressIndicator();
                        }
                        return Container();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        onSaved: (newValue) {
                          _title = newValue;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Title is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(hintText: "Title"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        onSaved: (newValue) {
                          _description = newValue;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Description is required";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(hintText: "Description"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: MaterialButton(
                          child: Text("Save"),
                          color: Colors.amber,
                          onPressed: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              print(_title);
                              PostModel model = PostModel(
                                  title: _title, description: _description);
                              BlocProvider.of<PostBloc>(context).add(PostCreate(
                                  token: widget.model.apiToken, model: model));
                            }
                          }),
                    )
                  ],
                )),
          ),
        ));
  }
}
