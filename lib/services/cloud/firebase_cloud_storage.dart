import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voteit/services/cloud/cloud_comments.dart';
import 'package:voteit/services/cloud/cloud_post.dart';
import 'package:voteit/services/cloud/cloud_storage_constants.dart';
import 'package:voteit/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final postsCollection = FirebaseFirestore.instance.collection('posts');
  final commentsCollection = FirebaseFirestore.instance.collection('comments');

  //singleton to create firebase cloud storage instance object
  factory FirebaseCloudStorage() => _shared;
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();

  Stream<Iterable<CloudPost>> allPosts({required String ownerUserId}) =>
      postsCollection.snapshots().map(
            (event) => event.docs.map(
              (doc) => CloudPost.fromSnapshot(doc),
            ),
          );

  //create new post
  Future<CloudPost> createNewPost({
    required String ownerUserId,
    required String text,
  }) async {
    final document = await postsCollection.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
      votesFieldName: <String, dynamic>{},
    });
    final fetchedPost = await document.get();

    return CloudPost(
      documentId: fetchedPost.id,
      ownerUserId: ownerUserId,
      text: text,
      votes: <String, dynamic>{},
    );
  }

  Future<void> updatePostVotes({
    required String documentId,
    required String email,
    required Map<String, dynamic>? votes,
    required int vote,
  }) async {
    if (votes == null) {
      votes = <String, dynamic>{email: vote};
    } else {
      try {
        votes.addAll({email: vote});

        await postsCollection.doc(documentId).update({
          votesFieldName: votes,
        });
      } catch (e) {
        throw CouldNotUpdatePostVotesException();
      }
    }
  }

  //TODO: only allow owner to update post
  Future<void> updatePost({
    required String documentId,
    required String text,
  }) async {
    try {
      await postsCollection.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdatePostException();
    }
  }

  //TODO: only allow owner to delete post
  Future<void> deletePost({required String documentId}) async {
    try {
      await postsCollection.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeletePostException();
    }
  }

  //Coments CRUD

  Stream<Iterable<CloudComment>> allComments({
    required String ownerUserId,
    required CloudPost post,
  }) =>
      postsCollection
          .doc(post.documentId)
          .collection('comments')
          .snapshots()
          .map(
            (event) => event.docs.map(
              (doc) => CloudComment.fromSnapshot(doc),
            ),
          );

  //create new post
  Future<CloudComment> createNewComment({
    required String ownerUserId,
    required String text,
    required CloudPost post,
  }) async {
    final document =
        await postsCollection.doc(post.documentId).collection('comments').add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
    });
    final fetchedComment = await document.get();

    return CloudComment(
      documentId: fetchedComment.id,
      ownerUserId: ownerUserId,
      text: text,
    );
  }
}
