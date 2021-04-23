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

  static Widget InventoryBuilding() {
    var assetImage = AssetImage("assets/images/inventory3.gif");
    var image = Image(
      image: assetImage,
      height: 180,
      width: 180,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(0),
    );
  }

  static Widget auth() {
    var assetImage = AssetImage("assets/images/auth.gif");
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


  static Widget authLock() {
    var assetImage = AssetImage("assets/images/authLock.gif");
    var image = Image(
      image: assetImage,
      height: 50,
      width: 50,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(0),
    );
  }

}
