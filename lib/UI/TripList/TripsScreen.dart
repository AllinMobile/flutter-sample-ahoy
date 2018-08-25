import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ahoy_sample/Services/Bridge.dart';
import 'package:ahoy_sample/Services/TripProvider.dart';
import 'package:ahoy_sample/Models/Stubs/TripStubs.dart';
import 'package:ahoy_sample/UI/Shared/AhoySegmentedControl.dart';
import 'TripsInteractor.dart';
import 'TripsSectionBuilder.dart';
import 'package:ahoy_sample/l10n/AhoyLocalizations.dart';

enum _Mode {
  me, everyone
}

class TripsScreen extends StatefulWidget {
  const TripsScreen({ Key key }) : super(key: key);
  @override State<StatefulWidget> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  _Mode _mode = _Mode.me;
  final GlobalKey<AnimatedListState> _meKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _everyoneKey = GlobalKey<AnimatedListState>();
  final TripProvider _meTripProvider = TripProvider(trips: TripStubs.stubMyTrips());
  final TripProvider _everyoneTripProvider = TripProvider(trips: TripStubs.stubEveryoneTrips());
  TripsInteractor _meTripInteractor;
  TripsInteractor _everyoneTripInteractor;

  @override void initState() {
    super.initState();
    _meTripInteractor = TripsInteractor(listKey: _meKey, tripProvider: _meTripProvider, sectionBuilder: MyTripsSectionBuilder());
    _everyoneTripInteractor = TripsInteractor(listKey: _everyoneKey, tripProvider: _everyoneTripProvider, sectionBuilder: EveryoneTripsSectionBuilder());
  }

  @override Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(leading: _backButton(),),
      child: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            _listForCurrentMode(),
            Positioned(
              bottom: 13.0,
              width: 190.0,
              height: 40.0,
              child: AhoySegmentedControl(segments:[
                AhoySegmentData(text: l10n(context).me, callback: () => _switchModeTo(_Mode.me)),
                AhoySegmentData(text: l10n(context).everyone, callback: () => _switchModeTo(_Mode.everyone))
              ]),
            ),
          ],
        )
      ),
    );
  }

  _switchModeTo(_Mode mode) {
    setState(() {
      this._mode = mode;
    });
  }

  Widget _listForCurrentMode() {
    TripsInteractor anInteractor;
    GlobalKey aKey;
    switch (_mode) {
      case _Mode.me:
        anInteractor = _meTripInteractor;
        aKey = _meKey;
        break;
      case _Mode.everyone:
        anInteractor = _everyoneTripInteractor;
        aKey = _everyoneKey;
        break;
    }
    return Material(
        child: AnimatedList(
          key: aKey,
          initialItemCount: anInteractor.count(),
          itemBuilder: anInteractor.buildRow,
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