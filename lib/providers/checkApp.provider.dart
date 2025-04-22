import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/providers/dio/get_dio.provider.dart';

/// Provider access.
/// Used in SplashScreen Widget.
final checkAppProvider = StateNotifierProvider<CheckAppNotifier, CheckAppState>(
  (ref) => CheckAppNotifier(ref),
);

/// When checking for the app, we want to know when it's loading, doing nothing, when failure income or when all is working correctly.
/// We want to send message to client to know that the loading is progressing.
class CheckAppState {
  final int status;

  static int none = 0;
  static int loading = 1;
  static int success = 2;
  static int failure = 3;

  CheckAppState({required this.status});
}

/// This simple provider will just make all calls required for the app to works.
/// For now, we are just testing that the server can be reached.
class CheckAppNotifier extends StateNotifier<CheckAppState> {
  final Ref ref;

  CheckAppNotifier(this.ref)
    : super(CheckAppState(status: CheckAppState.loading));

  Future runCheck() async {
    try {
      // Fetch the open API entrry route.
      final response = await ref.read(getDio).get("${dotenv.env["HOST"]}/");
      // When response is not a 200, it mean the server may have problems.
      if (response.statusCode != 200) {
        state = CheckAppState(status: CheckAppState.failure);
        return;
      }
      // Everything is ok, we notify the splashscreen that the server is all good.
      state = CheckAppState(status: CheckAppState.success);
    } catch (err) {
      // An error has been, we may reset the app in that case or push an error screen.
      if (kDebugMode) print(err);
      state = CheckAppState(status: CheckAppState.failure);
    }
  }
}
