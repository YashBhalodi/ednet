import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class AdminUsersList extends StatefulWidget {
  final User admin;

  const AdminUsersList({Key key, this.admin}) : super(key: key);

  @override
  _AdminUsersListState createState() => _AdminUsersListState();
}

class _AdminUsersListState extends State<AdminUsersList> with AutomaticKeepAliveClientMixin {
  int _totalStudentCount = 0;
  int _signedUpStudentCount = 0;
  int _totalProfCount = 0;
  int _signedUpProfCount = 0;
  List<DocumentSnapshot> _signedUpStudentsDocList = [];
  List<DocumentSnapshot> _signedUpProfDocList = [];
  bool _isLoading = false;
  final GlobalKey<AnimatedCircularChartState> _studentChartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final GlobalKey<AnimatedCircularChartState> _profChartKey =
      new GlobalKey<AnimatedCircularChartState>();

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    //counting total students and prof
    await Firestore.instance
        .collection('SignUpApplications')
        .where('university', isEqualTo: widget.admin.university)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((doc) {
        if (doc.data['type'] == 'prof') {
          _totalProfCount++;
        } else if (doc.data['type'] == 'student') {
          _totalStudentCount++;
        }
      });
    });

    //counting profile set students and profs and appending respective doc to respective list
    await Firestore.instance
        .collection('Users')
        .where('university', isEqualTo: widget.admin.university)
        .where('isProfileSet', isEqualTo: true)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((doc) {
        if (doc.data['isProf'] == true) {
          _signedUpProfCount++;
          _signedUpProfDocList.add(doc);
        } else if (doc.data['isProf'] == false && doc.data['isAdmin'] == false) {
          _signedUpStudentCount++;
          _signedUpStudentsDocList.add(doc);
        }
      });
    });
    List<CircularStackEntry> _profChartFinalData = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            _signedUpProfCount.floorToDouble(),
            Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.graphValueColor
                : LightTheme.graphValueColor,
            rankKey: 'signedup',
          ),
          CircularSegmentEntry(
            (_totalProfCount - _signedUpProfCount).floorToDouble(),
            Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.graphBackgroundColor
                : LightTheme.graphBackgroundColor,
            rankKey: 'total',
          ),
        ],
        rankKey: 'Professor',
      ),
    ];
    List<CircularStackEntry> _studentChartFinalData = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            _signedUpStudentCount.floorToDouble(),
            Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.graphValueColor
                : LightTheme.graphValueColor,
            rankKey: 'signedup',
          ),
          CircularSegmentEntry(
            (_totalStudentCount - _signedUpStudentCount).floorToDouble(),
            Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.graphBackgroundColor
                : LightTheme.graphBackgroundColor,
            rankKey: 'total',
          ),
        ],
        rankKey: 'Student',
      ),
    ];
    _studentChartKey.currentState.updateData(_studentChartFinalData);
    _profChartKey.currentState.updateData(_profChartFinalData);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              widget.admin.university,
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.headingStyle
                  : LightTheme.headingStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SummaryChartRow(
            profKey: _profChartKey,
            studentKey: _studentChartKey,
            studentCount: _signedUpStudentCount,
            profCont: _signedUpProfCount,
          ),
          SizedBox(
            height: 16,
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    ProfileSetStudents(
                      signedUpStudents: _signedUpStudentsDocList,
                    ),
                    ProfileSetProfs(
                      signedUpProfs: _signedUpProfDocList,
                    ),
                    const SizedBox(height: 16,),
                  ],
                ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileSetStudents extends StatelessWidget {
  final List<DocumentSnapshot> signedUpStudents;

  ProfileSetStudents({
    Key key,
    this.signedUpStudents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Students",
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.dropDownMenuTitleStyle
            : LightTheme.dropDownMenuTitleStyle,
      ),
      children: <Widget>[
        signedUpStudents.length == 0
            ? Container(
                height: 50.0,
                child: Center(
                  child: Text(
                    "No Student Signed Up yet",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.secondaryHeadingTextStyle
                        : LightTheme.secondaryHeadingTextStyle,
                  ),
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: signedUpStudents.length,
                itemBuilder: (_, i) {
                  User u = User.fromSnapshot(signedUpStudents[i]);
                  return ListTile(
                    title: Text(u.userName),
                    onTap: () {
                      Constant.userProfileView(context, userId: u.id);
                    },
                  );
                },
              ),
      ],
    );
  }
}

class ProfileSetProfs extends StatelessWidget {
  final List<DocumentSnapshot> signedUpProfs;

  const ProfileSetProfs({
    Key key,
    this.signedUpProfs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Professors",
        style: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.dropDownMenuTitleStyle
            : LightTheme.dropDownMenuTitleStyle,
      ),
      children: <Widget>[
        signedUpProfs.length == 0
            ? Container(
                height: 50.0,
                child: Center(
                  child: Text(
                    "No Professor Signed Up yet",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.secondaryHeadingTextStyle
                        : LightTheme.secondaryHeadingTextStyle,
                  ),
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: signedUpProfs.length,
                itemBuilder: (_, i) {
                  User u = User.fromSnapshot(signedUpProfs[i]);
                  return ListTile(
                    title: Text(u.userName),
                    onTap: () {
                      Constant.userProfileView(context, userId: u.id);
                    },
                  );
                },
              ),
      ],
    );
  }
}

class SummaryChartRow extends StatefulWidget {
  final GlobalKey studentKey;
  final GlobalKey profKey;
  final int studentCount;
  final int profCont;

  const SummaryChartRow({Key key, this.studentKey, this.profKey, this.studentCount, this.profCont})
      : super(key: key);

  @override
  _SummaryChartRowState createState() => _SummaryChartRowState();
}

class _SummaryChartRowState extends State<SummaryChartRow> with AutomaticKeepAliveClientMixin {
  List<CircularStackEntry> _studentChartInitData;
  List<CircularStackEntry> _profChartInitData;

  @override
  void didChangeDependencies() {
    _studentChartInitData = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            1,
            Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.graphBackgroundColor
                : LightTheme.graphBackgroundColor,
            rankKey: 'total',
          ),
        ],
        rankKey: 'Students',
      ),
    ];
    _profChartInitData = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            1,
            Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.graphBackgroundColor
                : LightTheme.graphBackgroundColor,
            rankKey: 'total',
          ),
        ],
        rankKey: 'Professor',
      ),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Spacer(
          flex: 1,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedCircularChart(
              key: widget.studentKey,
              size: const Size(150.0, 150.0),
              initialChartData: _studentChartInitData,
              chartType: CircularChartType.Radial,
              holeLabel: widget.studentCount.toString(),
              duration: Duration(milliseconds: 1500),
              holeRadius: 50.0,
              labelStyle: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.graphLabelStyle
                  : LightTheme.graphLabelStyle,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Students",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.graphDescriptionStyle
                  : LightTheme.graphDescriptionStyle,
            ),
          ],
        ),
        Spacer(
          flex: 1,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedCircularChart(
              key: widget.profKey,
              size: const Size(150.0, 150.0),
              initialChartData: _profChartInitData,
              chartType: CircularChartType.Radial,
              holeLabel: widget.profCont.toString(),
              duration: Duration(milliseconds: 1500),
              holeRadius: 50.0,
              labelStyle: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.graphLabelStyle
                  : LightTheme.graphLabelStyle,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Professors",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.graphDescriptionStyle
                  : LightTheme.graphDescriptionStyle,
            ),
          ],
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
