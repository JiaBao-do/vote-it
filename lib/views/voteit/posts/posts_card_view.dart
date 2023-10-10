import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:voteit/services/cloud/cloud_post.dart';
import 'package:voteit/views/voteit/card/card_view.dart';

typedef PostCallBack = void Function(CloudPost post);

class PostsCardView extends StatefulWidget {
  final Iterable<CloudPost> posts;
  //final PostCallBack onDeletePost;
  final PostCallBack onTap;

  const PostsCardView({
    super.key,
    required this.posts,
    //required this.onDeletePost,
    required this.onTap,
  });

  @override
  State<PostsCardView> createState() => _PostsCardViewState();
}

class _PostsCardViewState extends State<PostsCardView> {
  final _scrollController = FixedExtentScrollController();

  final double _itemHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return ClickableListWheelScrollView(
      scrollController: _scrollController,
      itemHeight: _itemHeight,
      itemCount: widget.posts.length,
      onItemTapCallback: (index) {
        final post = widget.posts.elementAt(index);
        widget.onTap(post);
      },
      child: ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: _itemHeight,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.002,
        diameterRatio: 1.9,
        squeeze: 1.0,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final post = widget.posts.elementAt(index);
            return CardView(
              post: post,
            );
          },
          childCount: widget.posts.length,
        ),
      ),
    );
  }
}
