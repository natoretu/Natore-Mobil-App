import 'package:flutter_test/flutter_test.dart';
import 'package:natore_project/model/product.dart';

void main() {
  test('product model test', () async {
    final product = Product(
      image: "Image",
      name: "some Name",
      properties: "some Properties",
      price: 233,
      ownerMail: "mail@mail.com",
    );

    expect(product.price, 233);
    expect(product.name, "some Name");
    expect(product.properties, "some Properties");
  });
}
