import 'package:book_store/base/base_event.dart';
import 'package:book_store/shared/model/product.dart';

class AddToCartEvent extends BaseEvent {
  Product product;

  AddToCartEvent(this.product);
}
