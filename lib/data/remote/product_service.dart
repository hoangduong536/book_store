/*
{
	"productName": "POKEMON ĐẶC BIỆT",
	"productImage": "https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/8/9/8935244801170.jpg",
	"quantity": 90,
	"price": 500000,
	"cateId": "KIDS"
}


{

	"productName":"ONE PIECE - TẬP 38",
	"productImage":"https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/8/9/8935244804102.jpg",
	"quantity":100,
	"price":18000,
	"cateId":"mega"

}
*/
import 'package:book_store/network/book_client.dart';
import 'package:book_store/shared/api_method_name.dart';
import 'package:dio/dio.dart';

class ProductService {
  Future<Response> getProductList() {
    return BookClient.instance.dio.get(
      APIMethodName.PRODUCT_LIST,
    );
  }
}
