import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxAttempts = 3;

class AdMobsAdsScreen extends StatefulWidget {
  const AdMobsAdsScreen({Key? key}) : super(key: key);

  @override
  BannarState createState() => BannarState();
}

class BannarState extends State<AdMobsAdsScreen> {
  late BannerAd bannerAd;
  InterstitialAd? interstitialAd;
  int intertialattemp = 0;
  RewardedAd? rewardedAd;
  int rewardaAdtemp = 0;

  static const AdRequest request = AdRequest();

  void loadbannarAD() {
    bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      request: request,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Write your code what you do when ads load
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          // Write your code what you do when ads Fails
          print('ad faild to load${error.message}');
        },
      ),
    );
    bannerAd.load();
  }

  void createinterstialad() {
    InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          intertialattemp = 0;
        },
        onAdFailedToLoad: (error) {
          intertialattemp++;
          interstitialAd = null;

          // Write your code what you do when ads error
          print("fail to load ${error.message}");

          if (intertialattemp <= maxAttempts) {
            createinterstialad();
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      // trying to show before loading when ads load
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        // Write your code what you do when ads load
      },
      onAdDismissedFullScreenContent: (ad) =>
          {ad.dispose(), createinterstialad()},
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        // Write your code what you do when ads Error
        print("faild to show the ad $ad");

        createinterstialad();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  void createRewardedad() {
    RewardedAd.load(
      adUnitId: RewardedAd.testAdUnitId,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          rewardaAdtemp = 0;
        },
        onAdFailedToLoad: (error) {
          rewardaAdtemp++;
          rewardedAd = null;
          // Write your code what you do when ads error
          print("fail to load ${error.message}");

          if (rewardaAdtemp <= maxAttempts) {
            createRewardedad();
          }
        },
      ),
    );
  }

  void showRewardedlAd() {
    if (rewardedAd == null) {
      // Write your code what you do when ads load trying to show before loading;
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          // Write your code what you do when ads load
        },
        onAdDismissedFullScreenContent: (ad) =>
            {ad.dispose(), createRewardedad()},
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          // Write your code what you do when ads error
          print("faild to show the ad $ad");

          createRewardedad();
        });
    rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        // Write your code what you do when ads load
        print("reward vidio ${reward.amount} ${reward.type}");
      },
    );
    rewardedAd = null;
  }

  @override
  void initState() {
    createinterstialad();
    createRewardedad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMOB ADS"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showInterstitialAd();
                    },
                    child: const Text("Show InterstialAD"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showRewardedlAd();
                    },
                    child: const Text("Show RewardedAd"),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Text(
                "====== Banner Ads in Listview Items ======",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ListView.builder(
                itemCount: 9,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  loadbannarAD();
                  if (index % 2 == 0) {
                    // ignore: sized_box_for_whitespace
                    return Container(
                      child: AdWidget(
                        ad: bannerAd,
                      ),
                      width: bannerAd.size.width.toDouble(),
                      height: bannerAd.size.height.toDouble(),
                    );
                  }
                  return ListTile(
                    title: Text("item${index + 1}"),
                    leading: const Icon(Icons.star),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
