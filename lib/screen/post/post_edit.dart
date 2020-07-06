import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:todolistv2/export.dart';

class PostEditScreen extends StatefulWidget {
  final UserModel model;
  final PostModel post;
  PostEditScreen({this.model, this.post});
  @override
  _PostEditScreenState createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _title, _description;
  _dialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Delete Post ?"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<PostBloc>(context).add(PostDelete(
                    token: widget.model.apiToken, id: widget.post.id));
              },
            ),
            SimpleDialogOption(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Post"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(FontAwesome.check_square_o),
                onPressed: () {
                  BlocProvider.of<PostBloc>(context).add(PostPinned(
                      token: widget.model.apiToken, id: widget.post.id));
                }),
            IconButton(
                icon: Icon(FontAwesome.trash_o),
                onPressed: () {
                  _dialog();
                }),
          ],
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
                        initialValue: widget.post.title,
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
                        initialValue: widget.post.description,
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
                              BlocProvider.of<PostBloc>(context).add(PostUpdate(
                                  token: widget.model.apiToken,
                                  model: model,
                                  id: widget.post.id));
                            }
                          }),
                    )
                  ],
                )),
          ),
        ));
  }
}
