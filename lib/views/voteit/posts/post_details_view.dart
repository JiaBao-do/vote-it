import 'package:flutter/material.dart';
import 'package:voteit/generics/get_arguments.dart';
import 'package:voteit/services/auth/auth_service.dart';
import 'package:voteit/services/cloud/cloud_comments.dart';
import 'package:voteit/services/cloud/cloud_post.dart';
import 'package:voteit/services/cloud/firebase_cloud_storage.dart';
import 'package:voteit/views/voteit/comment_view.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({super.key});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  late final FirebaseCloudStorage _cloudStorage;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CloudPost post = context.getArgument<CloudPost>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: StreamBuilder(
        stream: _cloudStorage.allComments(
          ownerUserId: userId,
          post: post,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allComments = snapshot.data as Iterable<CloudComment>;
                return CommentView(
                  comments: allComments,
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
