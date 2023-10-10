class CloudStorageException implements Exception {
  const CloudStorageException();
}

//C
class CouldNotCreatePostException extends CloudStorageException {}

//R
class CouldNotGetAllPostsException extends CloudStorageException {}

//U
class CouldNotUpdatePostException extends CloudStorageException {}

//D
class CouldNotDeletePostException extends CloudStorageException {}

class CouldNotUpdatePostVotesException extends CloudStorageException {}

//Comment

//C
class CouldNotCreateCommentException extends CloudStorageException {}
