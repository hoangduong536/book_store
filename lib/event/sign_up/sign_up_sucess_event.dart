

import 'package:book_store/base/base_event.dart';
import 'package:book_store/shared/model/user_data.dart';

class SignUpSuccessEvent extends BaseEvent {
  final UserData userData;
  SignUpSuccessEvent(this.userData);
}