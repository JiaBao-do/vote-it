import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voteit/constants/routes.dart';
import 'package:voteit/services/auth/auth_service.dart';
import 'package:voteit/services/auth/bloc/auth_bloc.dart';
import 'package:voteit/services/auth/bloc/auth_event.dart';
import 'package:voteit/services/cloud/cloud_post.dart';
import 'package:voteit/services/cloud/firebase_cloud_storage.dart';
import 'package:voteit/utilities/dialogs/logout_dialog.dart';
import 'package:voteit/views/voteit/posts/posts_card_view.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  late final FirebaseCloudStorage _cloudStorage;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Vote It'),
        actions: [
          IconButton(
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout && mounted) {
                  return context.read<AuthBloc>().add(const AuthEventLogOut());
                }
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: StreamBuilder(
        stream: _cloudStorage.allPosts(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allPosts = snapshot.data as Iterable<CloudPost>;
                return PostsCardView(
                  posts: allPosts,
                  onTap: (post) {
                    Navigator.of(context).pushNamed(
                      postViewRoute,
                      arguments: post,
                    );
                    Fluttertoast.showToast(msg: post.text);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(createPostRoute);
          },
          child: const Icon(Icons.add)),
    );
  }
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String get email => AuthService.firebase().currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          UserAccountsDrawerHeader(
            accountEmail: Text('email'),
            accountName: Text('username'),
            decoration: BoxDecoration(color: Colors.blue),
            currentAccountPicture: CircleAvatar(
              radius: 50.0,
              backgroundColor: Color(0xFF778899),
              backgroundImage: NetworkImage(
                  "https://scontent.fkul6-3.fna.fbcdn.net/v/t1.6435-9/52016980_2020974808017785_8180578149461917696_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=cdbe9c&_nc_ohc=aW6xJEGhO44AX9nsucQ&_nc_ht=scontent.fkul6-3.fna&oh=00_AfDW6Di0h6lG11ZckKZpQHQm717_1aKJaA89ffQnhrO7mA&oe=64D9F783"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
