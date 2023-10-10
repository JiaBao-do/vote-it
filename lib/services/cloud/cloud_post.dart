import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voteit/services/cloud/cloud_storage_constants.dart';

class CloudPost {
  final String documentId;
  final String ownerUserId;
  final String text;
  final Map<String, dynamic>? votes;

  const CloudPost({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.votes,
  });

  CloudPost.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName],
        votes = snapshot.data()[votesFieldName];
}
