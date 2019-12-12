

import 'package:book_store/base/base_event.dart';
import 'package:book_store/shared/model/product.dart';

class UpdateCartEvent extends BaseEvent {
  Product product;
  UpdateCartEvent(this.product);
}