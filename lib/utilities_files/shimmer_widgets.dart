import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerQuestionThumbCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 5.0,
      margin: Constant.cardMargin,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: Constant.cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        height: 16.0,
                        width: double.maxFinite - 30,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 32.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                            ),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Expanded(
                    flex: 5,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerArticleThumbCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 5.0,
      margin: Constant.cardMargin,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: Constant.cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        height: 16.0,
                        width: double.maxFinite - 30,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            SizedBox(
              height: 32.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                            ),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Expanded(
                    flex: 5,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShimmerAnswerThumbCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 5.0,
      margin: Constant.cardMargin,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: Constant.cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 22.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        height: 16.0,
                        width: double.maxFinite - 30,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 32.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                            ),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerQuestionPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 5.0,
      margin: Constant.cardMargin,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: Constant.cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        height: 16.0,
                        width: double.maxFinite - 30,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerArticlePreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 5.0,
      margin: Constant.cardMargin,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: Constant.cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              child: Container(
                width: double.maxFinite,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      child: Container(
                        height: 16.0,
                        width: double.maxFinite - 30,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerQuestionDraftCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 5.0,
      margin: Constant.cardMargin,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: Constant.cardPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[300],
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                        flex: 2,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[100],
                          highlightColor: Colors.grey[300],
                          child: Container(
                            height: 16.0,
                            width: double.maxFinite - 30,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 32.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.0,
                ),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerArticleDraftCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 5.0,
      margin: Constant.cardMargin,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: Constant.cardPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[300],
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                        flex: 2,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[100],
                          highlightColor: Colors.grey[300],
                          child: Container(
                            height: 16.0,
                            width: double.maxFinite - 30,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 32.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.0,
                ),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerAnswerDraftCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 5.0,
      margin: Constant.cardMargin,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: Constant.cardPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 22.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[300],
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                        flex: 2,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[100],
                          highlightColor: Colors.grey[300],
                          child: Container(
                            height: 16.0,
                            width: double.maxFinite - 30,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 32.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.0,
                ),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerQuestionTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(0.0, 3.0),
            blurRadius: 16.0,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        color: Colors.blue[50],
      ),
      margin: EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: Constant.edgePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[300],
                  child: Container(
                    width: double.maxFinite,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[300],
                        child: Container(
                          height: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[300],
                        child: Container(
                          height: 16.0,
                          width: double.maxFinite - 30,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 40.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[100],
                          highlightColor: Colors.grey[300],
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[100],
                          highlightColor: Colors.grey[300],
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerTopicTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      width: double.maxFinite,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 32.0,
            ),
            Shimmer.fromColors(
              child: Container(
                height: 24,
                width: 24.0,
                color: Colors.white,
              ),
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
            ),
            SizedBox(
              width: 16.0,
            ),
            Shimmer.fromColors(
              child: Container(
                height: 24,
                width: 200.0,
                color: Colors.white,
              ),
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerMainHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Shimmer.fromColors(
          child: Container(
            width: double.maxFinite,
            height: 64,
            color: Colors.white,
          ),
          baseColor: Colors.grey[100],
          highlightColor: Colors.grey[300],
        ),
        Spacer(),
        Align(
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            child: Text(
              "Loading...",
              style: TextStyle(
                fontSize: 36.0,
              ),
            ),
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[800],
            period: Duration(milliseconds: 800),
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                child: Container(
                  height: 64.0,
                  color: Colors.white,
                ),
                baseColor: Colors.grey[100],
                highlightColor: Colors.grey[300],
              ),
            ),
            SizedBox(
              width: 2.0,
            ),
            Expanded(
              child: Shimmer.fromColors(
                child: Container(
                  height: 64.0,
                  color: Colors.white,
                ),
                baseColor: Colors.grey[100],
                highlightColor: Colors.grey[300],
              ),
            ),
            SizedBox(
              width: 2.0,
            ),
            Expanded(
              child: Shimmer.fromColors(
                child: Container(
                  height: 64.0,
                  color: Colors.white,
                ),
                baseColor: Colors.grey[100],
                highlightColor: Colors.grey[300],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
