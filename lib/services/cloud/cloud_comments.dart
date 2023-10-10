import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voteit/services/cloud/cloud_storage_constants.dart';

class CloudComment {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudComment({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudComment.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName];
}
