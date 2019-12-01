


import 'package:book_store/base/base_event.dart';

class SignUpFailEvent extends BaseEvent {
  final String errMessage;
  SignUpFailEvent(this.errMessage);
}