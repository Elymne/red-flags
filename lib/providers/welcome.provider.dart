import 'package:flutter_riverpod/flutter_riverpod.dart';

final welcomeProvider = StateNotifierProvider<WelcomeNotifier, String?>((ref) => WelcomeNotifier());

class WelcomeNotifier extends StateNotifier<String?> {
  WelcomeNotifier() : super(null);

  Future callServer() async {}
}
