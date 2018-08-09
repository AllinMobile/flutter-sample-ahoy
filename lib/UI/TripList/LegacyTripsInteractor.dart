import 'package:flutter/material.dart';
import 'package:ahoy_sample/Models/Stubs/TripStubs.dart';
import 'package:ahoy_sample/UI/TripList/TripHeader.dart';
import 'TripCellFactory.dart';
import 'ListInteractorInterface.dart';

class LegacyTripsInteractor extends ListInteractor {
  final GlobalKey<AnimatedListState> listKey;
  final List<Widget> _cells = _allCells();

  LegacyTripsInteractor({@required this.listKey});

  int count() {
    return _cells.length;
  }

  Widget buildRow(BuildContext context, int index, Animation<double> animation) {
    return _cells[index];
  }

  static _allCells() {
      List<Widget> widgets = [];
      widgets.add(TripHeader(title: "Now", details: "12 March",));
      widgets.addAll(TripCellFactory.fromTrips([TripStubs.stubTodayTrip(id: 1)]));
      widgets.add(TripHeader(title: "Later"));
      widgets.addAll(TripCellFactory.fromTrips([TripStubs.stubLaterTrip(id: 2)]));
      return widgets;
    }
}