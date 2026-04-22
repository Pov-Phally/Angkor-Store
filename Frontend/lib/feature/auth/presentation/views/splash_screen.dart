import 'package:angkor_store/core/common/app/cache_helper.dart';
import 'package:angkor_store/core/common/widgets/angkor_store_logo.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/services/injection_container.dart';
import 'package:angkor_store/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/adapter/auth_adapter.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authAdapterProvider().notifier).verifyToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authAdapterProvider(), (previous, next) async {
      if (next is TokenVerified) {
        if (next.isValid) {
        } else
          await serviceLocater<CacheHelper>().resetSession();
        CoreUtils.postFrameCallback(() => context.go('/'));
      } else if (next is AuthError) {
        if (next.message.startsWith("401")) {
          await serviceLocater<CacheHelper>().resetSession();
          CoreUtils.postFrameCallback(() => context.go('/'));
          return;
        }
      }
    });
    return Scaffold(
      backgroundColor: Colours.lightThemePrimaryColor,
      body: Center(child: AngKorStoreLogo()),
    );
  }
}
