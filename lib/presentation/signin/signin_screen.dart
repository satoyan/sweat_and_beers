
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweat_and_beers/presentation/signin/signin_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GetBuilder<SignInController>(
      init: SignInController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.signInScreenTitle),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Google Sign-in
                    controller.signInWithGoogle();
                  },
                  child: Text(l10n.signInWithGoogle),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Facebook Sign-in
                    controller.signInWithFacebook();
                  },
                  child: Text(l10n.signInWithFacebook),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
