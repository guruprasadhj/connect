import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


/// Event subscription class
class FlutterNavigationBarSubscriber {
  /// Called when a layout change event occurs
  /// [navigationBarInfo] parameter see declaration below
  final Function(NavigationBarInfo navigationBarInfo) onChange;

  FlutterNavigationBarSubscriber({this.onChange});
}

/// The notification class that handles all events
class FlutterNavigationBarNotification {
  static const EventChannel _navigationBarInfoStream = const EventChannel('github.com/pontusbredin/flutter_navigation_bar');
  static Map<int, FlutterNavigationBarSubscriber> _list = Map<int, FlutterNavigationBarSubscriber>();
  static StreamSubscription _navigationBarInfoSubscription;
  static int _currentIndex = 0;

  /// Set initial state
  NavigationBarInfo _navigationBarInfo = NavigationBarInfo(false, 0.0, 0.0, 0.0, 0.0);

  /// Constructor
  FlutterNavigationBarNotification() {
    _navigationBarInfoSubscription ??= _navigationBarInfoStream
        .receiveBroadcastStream()
        .listen(onSystemBarsEvent);
  }

  /// Internal function to handle native code channel communication.
  /// The native code (Android) will send a message to this class.
  void onSystemBarsEvent(dynamic arg) {
    if (arg != null) {
      Map<dynamic, dynamic> map = (arg as Map<dynamic, dynamic>);
      _navigationBarInfo = NavigationBarInfo(
          map['hasSoftwareNavigationBar'], map['navigationBarHeight'], map['navigationBarWidthLeft'], map['navigationBarWidthRight'], map['statusBarHeight']);

      /// Tell all subscribers about the event
      _list.forEach((subscriber, s) {
        try {
          if (s.onChange != null) {
            s.onChange(_navigationBarInfo);
          }
        } catch (_) {}
      });
    }
  }

  /// Returns a subscribing id that can be used to unsubscribe
  int addNewListener(
      {Function(NavigationBarInfo navigationBarInfo) onChange}) {
    _list[_currentIndex] = FlutterNavigationBarSubscriber(
        onChange: onChange);
    return _currentIndex++;
  }

  /// Returns a subscribing id that can be used to unsubscribe
  int addNewSubscriber(FlutterNavigationBarSubscriber subscriber) {
    _list[_currentIndex] = subscriber;
    return _currentIndex++;
  }

  /// Unsubscribe
  /// [subscribingId] has to contain an id previously returned on addNewListener or addNewSubscriber
  void removeListener(int subscribingId) {
    _list.remove(subscribingId);
  }

  /// Internal function to clear class on dispose
  dispose() {
    _list.clear();
    _navigationBarInfoSubscription?.cancel()?.catchError((e) {});
    _navigationBarInfoSubscription = null;
  }
}

class FlutterNavigationBar {
  static final FlutterNavigationBar _singleton = FlutterNavigationBar._internal();
  static const MethodChannel _channel = const MethodChannel('flutter_navigation_bar');

  BuildContext _context = null;
  State<StatefulWidget> _stateWidget;
  bool _hasSoftwareNavigationBar = false;
  double _navigationBarHeight = 0.0;
  double _navigationBarWidthLeft = 0.0;
  double _navigationBarWidthRight = 0.0;
  double _statusBarHeight = 0.0;
  FlutterNavigationBarNotification _flutterNavigationBarNotification;
  bool _useEqualSides = false;

  bool get hasSoftwareNavigationBar {
    return _hasSoftwareNavigationBar;
  }

  double get navigationBarHeight {
    if ((Platform.isIOS) && (_context != null)) {
      return MediaQuery.of(_context).viewPadding.bottom + MediaQuery.of(_context).viewInsets.bottom;
    } else {
      return _navigationBarHeight;
    }
  }

  double get navigationBarWidthLeft {
    if ((Platform.isIOS) && (_context != null)) {
      return MediaQuery.of(_context).padding.left;
    } else {
      return _navigationBarWidthLeft;
    }
  }

//  void set navigationBarWidthLeft(double aValue) {
//    _navigationBarWidthLeft = aValue;
//  }

  double get navigationBarWidthRight {
    if ((Platform.isIOS) && (_context != null)) {
      return MediaQuery.of(_context).padding.right;
    } else {
      return _navigationBarWidthRight;
    }
  }

//  void set navigationBarWidthRight(double aValue) {
//    _navigationBarWidthRight = aValue;
//  }

  double get statusBarHeight {
    if ((Platform.isIOS) && (_context != null)) {
      return MediaQuery.of(_context).viewPadding.top;
    } else {
      return _statusBarHeight;
    }
  }

  bool get equalSides {
    return _useEqualSides;
  }

  ///Set equal width to the two sides in landscape
  ///Doesn't really work that well with the soft keyboard
  set equalSides(bool value) {
    _channel.invokeMethod('equalSides', {'bool':value}).then((onValue){
      _useEqualSides = onValue;
    });
  }

  ///This is a singleton
  factory FlutterNavigationBar({State<StatefulWidget> set_to_this}) {
    if (set_to_this != null) {
      _singleton._stateWidget = set_to_this;
      _singleton._context = set_to_this.context;
    }
    if (_singleton._flutterNavigationBarNotification == null) {
      _singleton._flutterNavigationBarNotification = FlutterNavigationBarNotification()..addNewListener(
        onChange: (navigationBarInfo){
          _singleton._hasSoftwareNavigationBar = navigationBarInfo.hasSoftwareNavigationBar;
          _singleton._navigationBarHeight = navigationBarInfo.navigationBarHeight;
          _singleton._navigationBarWidthLeft = navigationBarInfo.navigationBarWidthLeft;
          _singleton._navigationBarWidthRight = navigationBarInfo.navigationBarWidthRight;
          _singleton._statusBarHeight = navigationBarInfo.statusBarHeight;
          if (_singleton._stateWidget != null) {
            _singleton._stateWidget.setState((){});
          }
        },
      );
    }
    return _singleton;
  }

  FlutterNavigationBar._internal();

}


class NavigationBarInfo {
  NavigationBarInfo(this.hasSoftwareNavigationBar, this.navigationBarHeight, this.navigationBarWidthLeft, this.navigationBarWidthRight, this.statusBarHeight);

  final bool hasSoftwareNavigationBar;
  final double navigationBarHeight;
  final double navigationBarWidthLeft;
  final double navigationBarWidthRight;
  final double statusBarHeight;

  static NavigationBarInfo fromJson(dynamic json) {
    return NavigationBarInfo(json['hasSoftwareNavigationBar'], json['navigationBarHeight'], json['navigationBarWidthLeft'], json['navigationBarWidthRight'], json['statusBarHeight']);
  }

}