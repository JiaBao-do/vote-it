import 'package:flutter/material.dart';
import 'package:voteit/services/auth/auth_service.dart';
import 'package:voteit/services/cloud/cloud_post.dart';
import 'package:voteit/services/cloud/cloud_storage_exceptions.dart';
import 'package:voteit/services/cloud/firebase_cloud_storage.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  CloudPost? _post;
  late final FirebaseCloudStorage _cloudStorage;
  late final TextEditingController _textController;

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

  Future<CloudPost> _createPost(BuildContext context) async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final text = _textController.text;
    if (text.trim().isNotEmpty) {
      final newPost = await _cloudStorage.createNewPost(
        ownerUserId: userId,
        text: text,
      );
      _post = newPost;
      return newPost;
    } else {
      Navigator.of(context).pop();
      throw CouldNotCreatePostException();
    }
  }

  void _textControllerListener() async {
    final note = _post;
    if (note == null) return;
    final text = _textController.text;
    await _cloudStorage.updatePost(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListner() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: StreamBuilder(
        stream: const Stream.empty(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListner();
              return Column(
                children: [
                  TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    maxLength: 500,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText:
                            'What do you thing...?  (max 500 characters)'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _createPost(context);
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: const Text('Post'),
                      ),
                    ),
                  ),
                ],
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
