import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:foodkut_driver/feature/order/controllers/order_controller.dart';
import 'package:foodkut_driver/util/dimensions.dart';
import 'package:foodkut_driver/util/images.dart';
import 'package:foodkut_driver/util/styles.dart';
import 'package:foodkut_driver/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRequestDialogWidget extends StatefulWidget {
  final bool isRequest;
  final Function onTap;
  final int orderId;
  const NewRequestDialogWidget({super.key, required this.isRequest, required this.onTap, required this.orderId});

  @override
  State<NewRequestDialogWidget> createState() => _NewRequestDialogWidgetState();
}

class _NewRequestDialogWidgetState extends State<NewRequestDialogWidget> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startAlarm();
    Get.find<OrderController>().getOrderDetails(widget.orderId);
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  void _startAlarm() {
    AudioPlayer audio = AudioPlayer();
    //audio.play('notification.mp3');
    audio.play(AssetSource('notification.mp3'));
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      //audio.play('notification.mp3');
      audio.play(AssetSource('notification.mp3'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: GetBuilder<OrderController>(builder: (orderController) {
          return Column(mainAxisSize: MainAxisSize.min, children: [

            Image.asset(Images.notificationIn, height: 60, color: Theme.of(context).primaryColor),

            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeSmall),
              child: Text(
                widget.isRequest ? 'new_order_request_from_a_customer'.tr : 'you_have_assigned_a_new_order'.tr, textAlign: TextAlign.center,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
            ),

            orderController.orderDetailsModel != null ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [

              Text('with'.tr , textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

              Text(
                ' ${orderController.orderDetailsModel != null ? orderController.orderDetailsModel!.length.toString() : 0} ',
                textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),

              Text('items'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

            ]) : const SizedBox(),

            orderController.orderDetailsModel != null ? ListView.builder(
              itemCount: orderController.orderDetailsModel!.length,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                itemBuilder: (context,index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [

                  Text('${'item'.tr} ${index + 1}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Flexible(child: Text(
                    '${orderController.orderDetailsModel![index].foodDetails!.name!} ( x ${orderController.orderDetailsModel![index].quantity})',
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  )),

                ]),
              );
            }) : const SizedBox(),

            CustomButtonWidget(
              height: 40,
              buttonText: widget.isRequest ? (Get.find<OrderController>().currentOrderList != null
                && Get.find<OrderController>().currentOrderList!.isNotEmpty) ? 'ok'.tr : 'go'.tr : 'ok'.tr,
              onPressed: () {
                if(!widget.isRequest) {
                  _timer?.cancel();
                }
                Get.back();
                widget.onTap();
              },
            ),

          ]);
        }),
      ),
    );
  }
}