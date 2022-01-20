import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/page/home_page.dart';

CollectionReference products =
    FirebaseFirestore.instance.collection('Products');
CollectionReference users = FirebaseFirestore.instance.collection('Users');
CollectionReference rates = FirebaseFirestore.instance.collection('Rates');
bool flag = false;
Future<void> saveRate(String productId, int rate) async {
  await doesUserHasRateForThisProduct(productId);
  if (flag == true) {
    // user already rated this product
    return;
  }
  double oldRate = 0;
  int ratedTimesTaken = 0;
  var documentSnapshot = await products.doc(productId).get();

  if (documentSnapshot.exists) {
    var oldRateTemp = documentSnapshot.get('rate');
    oldRate = (oldRateTemp is int) ? oldRateTemp.toDouble() : oldRateTemp;
    ratedTimesTaken = documentSnapshot.get('ratedTimes');
    //print('Document dataqqqqqqqqqqq: ${documentSnapshot.data()}');
  } else {
    print('Document does not exist on the database qqqqqqqqqqqq');
  }

  double newRate = (ratedTimesTaken * oldRate + rate) / (ratedTimesTaken + 1);
  //print(newRate.toString() + "EEEEEEEE");
  await updateRateIncreaseRatedTimes(
      products, productId, newRate, ratedTimesTaken + 1);
  await showThatUserRatedThisProduct(productId);
  //String takeSellerMail = products.get(productId).get();
  var documentProduct = products.doc(productId);
  String mailOfSeller = "";
  await documentProduct.get().then((value) {
    mailOfSeller = value.get('mail');
  });
  print("users: mail of seller:" + mailOfSeller);
  //await
  await updateSellersRateAndRatedTimes(mailOfSeller, rate);
}

/*updateSellersRate(String mailOfSeller) {
  updateSellersRateAndRatedTimes(mailOfSeller);
}*/

Future<void> updateSellersRateAndRatedTimes(
    String mailOfSeller, int rateGivenToProduct) async {
  /*var productsOfSeller = products.where('mail', isEqualTo: mailOfSeller);
  productsOfSeller.get().then((value) {
    value.docs.forEach((element) {
      print(element.get('name'));
    });
    //print(value.docs.forEach((element) { }))
  });*/
  double oldRate = 0;
  int ratedTimesTaken = 0;
  //var documentSnapshot = await users.doc().get();
  var sellerDoc = users.where('Email', isEqualTo: mailOfSeller);
  //.where('user', isEqualTo: user!.email);
  /*if (seller.exists) {
    oldRate = documentSnapshot.get('rate');
    ratedTimesTaken = documentSnapshot.get('ratedTimes');
    //print('Document dataqqqqqqqqqqq: ${documentSnapshot.data()}');
  } else {
    print('Document does not exist on the database qqqqqqqqqqqq');
  }*/
  await sellerDoc.get().then((value) {
    // there is only one person with 1 email
    var seller = value.docs.first;
    oldRate = seller.get('rate');
    ratedTimesTaken = seller.get('ratedTimes');
  });

  double newRate =
      (ratedTimesTaken * oldRate + rateGivenToProduct) / (ratedTimesTaken + 1);
  //print(newRate.toString() + "EEEEEEEE");
  await updateRateIncreaseRatedTimes(
      users, mailOfSeller, newRate, ratedTimesTaken + 1);
}

String takeIdOfRateForCurrentUserAndGivenProductId(String productId) {
  return (user!.email.toString() + productId);
}

Future<void> showThatUserRatedThisProduct(String productId) async {
  //await rates.add({'user': user!.email, 'productId': productId});
  await rates
      .doc(takeIdOfRateForCurrentUserAndGivenProductId(productId))
      .set({'user': user!.email, 'productId': productId});
}

Future<void> doesUserHasRateForThisProduct(String productId) async {
  var documentSnapshot = rates
      .where('productId', isEqualTo: productId)
      .where('user', isEqualTo: user!.email);
  //var documentSnapshot = rates.get(takeIdOfRateForCurrentUserAndGivenProductId(productId));
  await documentSnapshot.get().then((value) {
    if (value.size == 0 || value.docs.isEmpty) {
      flag = false;
    } else {
      flag = true;
    }
  });
}

Future<void> updateRateIncreaseRatedTimes(CollectionReference collection,
    String docId, double newRate, int newRatedTimesTaken) async {
  await collection
      .doc(docId)
      .update({'rate': newRate, 'ratedTimes': newRatedTimesTaken});
}
