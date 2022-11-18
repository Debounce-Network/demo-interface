import 'package:debounce/components/button/account_button.dart';
import 'package:debounce/components/network/network_selector.dart';
import 'package:debounce/components/topbar/topbar.dart';
import 'package:debounce/controller/connector.dart';
import 'package:debounce/controller/debounce_controller.dart';
import 'package:debounce/demo.dart';
import 'package:debounce/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  Get.put(ConnectController()..start());
  Get.put(DebounceController()..start());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Debounce Demo',
      theme: ThemeData(
          primaryColor: blackPrimary,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: GoogleFonts.ubuntuMono().fontFamily,
          textTheme: TextTheme(
            bodyLarge: fontStyle.copyWith(fontSize: 32),
            bodyMedium: fontStyle,
            bodySmall: fontStyle.copyWith(fontSize: 16),
            titleLarge: fontStyle.copyWith(fontSize: 64),
            titleMedium: fontStyle.copyWith(fontSize: 48),
            titleSmall: fontStyle.copyWith(fontSize: 32),
          )),
      initialRoute: '/',
      getPages: [GetPage(name: '/', page: () => const Home())],
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  createTx() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: SingleChildScrollView(
          child: Column(children: [
        _Wrapper(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [NetworkSelector(), AccountButton()],
            ),
            const SizedBox(
              height: 16,
            ),
            Demo(),
          ]),
        ),
        const SizedBox(
          height: 32,
        ),
      ])),
    );
  }
}

class _Wrapper extends StatelessWidget {
  const _Wrapper({required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: Container(padding: padding, constraints: const BoxConstraints(maxWidth: 680), child: child));
  }
}
