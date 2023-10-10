import 'package:flutter/material.dart';
import 'package:voteit/services/auth/auth_service.dart';
import 'package:voteit/services/auth/auth_user.dart';
import 'package:voteit/services/cloud/cloud_comments.dart';
import 'package:voteit/services/cloud/cloud_post.dart';
import 'package:voteit/services/cloud/cloud_storage_exceptions.dart';
import 'package:voteit/services/cloud/firebase_cloud_storage.dart';
import 'package:voteit/utilities/dialogs/generics/get_arguments.dart';
import 'package:voteit/views/voteit/card/card_view.dart';

class CommentView extends StatefulWidget {
  final Iterable<CloudComment> comments;
  const CommentView({
    super.key,
    required this.comments,
  });

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  late final FirebaseCloudStorage _cloudStorage;
  late final TextEditingController _textController;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<CloudComment> _createComment(
    BuildContext context,
    CloudPost post,
  ) async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final text = _textController.text;

    if (text.trim().isNotEmpty) {
      final newComment = await _cloudStorage.createNewComment(
        ownerUserId: userId,
        text: text,
        post: post,
      );

      return newComment;
    } else {
      throw CouldNotCreateCommentException();
    }
  }

  List<Widget> createListTitle(Iterable<CloudComment> comments) {
    return List.generate(
      comments.length,
      (index) {
        return ListTile(
          title: Text(comments.elementAt(index).text),
          dense: false,
          iconColor: Colors.green,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CloudPost post = context.getArgument<CloudPost>()!;
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: [
              SizedBox(
                height: 250.0,
                child: CardView(post: post),
              ),
              Column(
                children: createListTitle(widget.comments),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // First child is enter comment text input
              Expanded(
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  maxLength: 100,
                  autofocus: true,
                  decoration:
                      const InputDecoration(hintText: 'Leave a comment!'),
                ),
              ),
              // Second child is button
              IconButton(
                icon: const Icon(Icons.send),
                iconSize: 20.0,
                onPressed: () async {
                  await _createComment(context, post);
                  _textController.clear();
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
