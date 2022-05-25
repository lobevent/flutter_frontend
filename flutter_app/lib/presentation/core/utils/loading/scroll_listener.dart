import 'package:flutter/material.dart';

class ScrollListener{
  ScrollListener({required this.loadMore}){
    controller.addListener(_scrollListener);
  }
  VoidCallback loadMore;
  ScrollController controller = ScrollController();
  bool endReached = false;

    _scrollListener(){
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if(!endReached) {
        loadMore();
      }
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
    }
  }

  setEndReached(bool reached){
      this.endReached =reached;
  }


}