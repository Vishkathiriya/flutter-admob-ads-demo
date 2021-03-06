import 'package:admob/ad_mob_ads_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdMobsAdsScreen(),
    ),
  );
}
