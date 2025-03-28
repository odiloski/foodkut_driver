import 'package:foodkut_driver/feature/profile/controllers/profile_controller.dart';
import 'package:foodkut_driver/helper/price_converter_helper.dart';
import 'package:foodkut_driver/util/dimensions.dart';
import 'package:foodkut_driver/util/styles.dart';
import 'package:foodkut_driver/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncentiveScreen extends StatefulWidget {
  const IncentiveScreen({super.key});

  @override
  State<IncentiveScreen> createState() => _IncentiveScreenState();
}

class _IncentiveScreenState extends State<IncentiveScreen> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'incentive'.tr),

      body: GetBuilder<ProfileController>(builder: (profileController) {

        for (var incentive in profileController.profileModel!.incentiveList!) {
          if(incentive.earning! < profileController.profileModel!.todaysEarning!){
            selectedIndex = profileController.profileModel!.incentiveList!.indexOf(incentive);
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Container(
              height: 150, width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Center(child: Text(
                '${'you_have_total_incentive'.tr}\n${PriceConverter.convertPrice(profileController.profileModel!.totalIncentiveEarning)}',
                textAlign: TextAlign.center, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor),
              )),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Text('current_incentive_offers'.tr, style: robotoMedium),
            ),

            profileController.profileModel!.incentiveList!.isNotEmpty ? ListView.builder(
              shrinkWrap: true,
              itemCount: profileController.profileModel!.incentiveList!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: selectedIndex == index ? Colors.green : Theme.of(context).cardColor, width: 2),
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                    child: Column(children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Text('earning'.tr, style: robotoMedium),

                        Text('incentive'.tr, style: robotoMedium),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Text(PriceConverter.convertPrice(profileController.profileModel!.incentiveList![index].earning), style: robotoMedium),

                        Text(PriceConverter.convertPrice(profileController.profileModel!.incentiveList![index].incentive), style: robotoMedium),

                      ]),

                    ]),
                  ),
                );
              },
            ) : Text('no_offer_available'.tr, style: robotoBold),

          ]),
        );
      }),
    );
  }
}