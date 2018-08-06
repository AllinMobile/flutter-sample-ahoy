import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ahoy_sample/Services/Bridge.dart';
import 'package:ahoy_sample/Services/TripProvider.dart';
import '../Shared/AhoyStyles.dart';
import '../Shared/AhoyWidgets.dart';
import 'TripCellFactory.dart';

class TripsScreen extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(leading: _backButton(),),
      child: SafeArea(
        child: Padding(padding: EdgeInsets.only(top: 4.0), child: TripList(),),
        // child: TripList(),
        ),
    );
  }

  _backButton() {
    return CupertinoButton(
      child: Icon(CupertinoIcons.back),
      onPressed: (){
        Bridge().dismiss();
      },
    );
  }
}

class TripList extends StatefulWidget {
  @override _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> with WidgetsBindingObserver {
  
  bool isLoaded = false;
  final tripProvider = TripProvider();

  @override void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !isLoaded) {
      isLoaded = true;
      _hideSplash();
    }
  }

  void _hideSplash() {
    Bridge().viewReady();
  }

  @override Widget build(BuildContext context) {
    return Material(
        child: ListView(
        children: _allCells(),
    ));
  }

  _allCells() {
      List<Widget> widgets = [];
      widgets.add(_headerFor("Now", "12 March"));
      widgets.addAll(TripCellFactory.fromTrips(tripProvider.tripsNow()));
      widgets.add(_headerFor("Later", ""));
      widgets.addAll(TripCellFactory.fromTrips(tripProvider.tripsLater()));
      return widgets;
    }

  _headerFor(String title, String date) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Row(children: <Widget>[
        Text(title, style: AhoyStyles.list.titleStyle,),
        AhoyWidgets.flexibleSpace(),
        Text(date, style: AhoyStyles.list.headerDetailsStyle,),
      ],),
    );
  }
}
