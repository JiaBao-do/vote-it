import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:voteit/services/auth/auth_service.dart';
import 'package:voteit/services/cloud/cloud_post.dart';
import 'package:voteit/services/cloud/firebase_cloud_storage.dart';

class CardView extends StatefulWidget {
  final CloudPost post;

  const CardView({
    super.key,
    required this.post,
  });

  @override
  State<CardView> createState() => _CardViewState();
}

Color _checkDirectionResult(SwipeDirection direction) {
  switch (direction) {
    case SwipeDirection.startToEnd:
      return const Color.fromARGB(255, 0, 255, 0);
    case SwipeDirection.endToStart:
      return const Color.fromARGB(255, 255, 0, 0);
    default:
      return const Color.fromARGB(255, 255, 255, 255);
  }
}

class _CardViewState extends State<CardView> {
  late final FirebaseCloudStorage _cloudStorage;
  String get userEmail => AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var agree = 0;
    var total = 0;
    var disagree = 0;
    var percent = 0.0;
    late String text;
    late Map<String, dynamic>? votes;

    final post = widget.post;
    text = post.text;
    votes = post.votes;

    if (votes!.isNotEmpty) {
      for (int v in votes.values) {
        total++;
        agree += v;
      }
      disagree = total - agree;
      percent = agree / total;
    }

    return SwipeableTile.swipeToTriggerCard(
      key: UniqueKey(),
      backgroundBuilder: (context, direction, progress) {
        return AnimatedBuilder(
          animation: progress,
          builder: (context, child) {
            return AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                color: _checkDirectionResult(direction));
          },
        );
      },
      horizontalPadding: 16,
      verticalPadding: 8,
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.35),
        blurRadius: 4,
        offset: const Offset(2, 2),
      ),
      color: Colors.blue,
      onSwiped: (direction) async {
        switch (direction) {
          case SwipeDirection.startToEnd:
            {
              await _cloudStorage.updatePostVotes(
                email: userEmail,
                documentId: post.documentId,
                votes: votes,
                vote: 1,
              );
            }
          case SwipeDirection.endToStart:
            {
              await _cloudStorage.updatePostVotes(
                email: userEmail,
                documentId: post.documentId,
                votes: votes,
                vote: 0,
              );
            }
          default:
        }
      },
      swipeThreshold: 0.3,
      direction: SwipeDirection.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text("${percent * 100}%"),
            LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              width: 170.0,
              animation: true,
              animationDuration: 500,
              lineHeight: 20.0,
              leading: Text("$agree Agree"),
              trailing: Text("Disagree $disagree"),
              percent: percent,
              progressColor: votes.isNotEmpty
                  ? const Color.fromARGB(255, 0, 255, 0)
                  : const Color.fromARGB(255, 151, 151, 151),
              backgroundColor: votes.isNotEmpty
                  ? const Color.fromARGB(255, 255, 0, 0)
                  : const Color.fromARGB(255, 151, 151, 151),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}
