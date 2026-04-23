import 'package:angkor_store/core/common/app/cache_helper.dart';
import 'package:angkor_store/core/common/singletons/cache.dart';
import 'package:angkor_store/core/common/widgets/angkor_store_logo.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/services/injection_container.dart';
import 'package:angkor_store/feature/auth/presentation/app/adapter/auth_cubit.dart';
import 'package:angkor_store/feature/user/app/adapter/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().verifyToken();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) async {
        if (state is UserError) {
          final router = GoRouter.of(context);
          await serviceLocater<CacheHelper>().resetSession();
          router.go('/');
        } else if (state is FetchedUser) {
          context.go('/', extra: ('home'));
        }
      },
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is TokenVerified) {
            if (state.isValid) {
              context.read<UserCubit>().getUserById(Cache.instance.userId!);
            } else {
              final router = GoRouter.of(context);
              await serviceLocater<CacheHelper>().resetSession();
              router.go('/');
            }
          } else if (state is AuthError) {
            final router = GoRouter.of(context);
            await serviceLocater<CacheHelper>().resetSession();
            router.go('/');
          }
        },

        child: Scaffold(
          backgroundColor: Colours.lightThemePrimaryColor,
          body: Center(child: AngKorStoreLogo()),
        ),
      ),
    );
  }
}
