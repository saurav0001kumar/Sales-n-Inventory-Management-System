import 'package:flutter/material.dart';

class ImageAssets {
  static Widget appIcon() {
    var assetImage = AssetImage("assets/images/app_icon.png");
    var image = Image(
      image: assetImage,
      height: 200,
      width: 200,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(0),
    );
  }

  static Widget InventoryChecking() {
    var assetImage = AssetImage("assets/images/inventory1.gif");
    var image = Image(
      image: assetImage,
      height: 150,
      width: 150,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(0),
    );
  }

  static Widget InventoryLoading() {
    var assetImage = AssetImage("assets/images/inventory2.gif");
    var image = Image(
      image: assetImage,
      height: 210,
      width: 210,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(0),
    );
  }
}