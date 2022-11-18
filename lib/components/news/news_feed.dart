import 'dart:math';

import 'package:debounce/components/loading/loading.dart';
import 'package:debounce/components/rect/dash_rect.dart';
import 'package:debounce/constant/chain.dart';
import 'package:debounce/contract/metabuild_contract.dart';
import 'package:debounce/model/news.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class NewsFeedController extends GetxController {
  static const String _newsAaddress = '0xFABB0ac9d68B0B445fB7357272Ff202C5651694a';

  RxList<News> _news = <News>[].obs;

  List<News> get news => _news.value;

  @override
  void onInit() async {
    super.onInit();

    final contract = MetabuildContract.fromChainId(ChainId.DEBOUNCE);
    final offset = await contract.getOffsets(_newsAaddress);

    final resp = await contract.getMessages(_newsAaddress, offset, limit: 150, desc: true);
    final list = resp.map((each) => News(title: each.split('&url=')[0], link: each.split('&url=')[1]));
    final seen = <String, News>{};
    list.map((each) => seen[each.title.toLowerCase().trim()] = each).toList();

    _news.value = seen.values.toList().sublist(0, min(10, seen.length));
    _news.refresh();
  }
}

String marketplaceMessage = 'Debounce is also a data marketplace.If you want to sell your data, you can do so by participating in the Debounce Node.';

class NewsFeed extends GetView<NewsFeedController> {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NewsFeedController());

    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: Text("Demo #2 - Data Marketplace", style: Get.textTheme.titleMedium)),
        const SizedBox(height: 24),
        Text(marketplaceMessage),
        const SizedBox(
          height: 24,
        ),
        DashedRect(
            child: Container(
                constraints: const BoxConstraints(minHeight: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  if (controller.news.isEmpty) return const Center(child: Loading());

                  return Column(
                    children: controller.news
                        .map((each) => InkWell(
                            onTap: () {
                              html.window.open(each.link, '_blank');
                            },
                            child: Container(padding: const EdgeInsets.all(16), child: Align(alignment: Alignment.center, child: Text(each.title)))))
                        .toList(),
                  );
                })))
      ],
    );
  }
}
