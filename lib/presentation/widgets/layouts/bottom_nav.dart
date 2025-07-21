import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/presentation/router/router.notifier.dart';
import 'package:red_flags/presentation/screens/create_person_screen/create_person_screen.dart';
import 'package:red_flags/presentation/screens/home_screen/home_screen.dart';
import 'package:red_flags/presentation/viewmodels/current_screen.provider.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState {
  late final currentScreenNotifier = ref.read(currentScreenProvider.notifier);
  late final routerNotifier = ref.read(routerNotifierprovider.notifier);

  @override
  Widget build(BuildContext context) {
    final currentScreen = ref.watch(currentScreenProvider);
    final theme = Theme.of(context);

    return NavigationBar(
      animationDuration: Duration(milliseconds: 1000),
      backgroundColor: theme.colorScheme.onSurface,
      elevation: 10,
      indicatorColor: theme.colorScheme.primary,
      indicatorShape: StadiumBorder(),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((Set<WidgetState> states) {
        return TextStyle(color: theme.colorScheme.surface);
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        return theme.colorScheme.secondary;
      }),
      selectedIndex: currentScreen.data,
      onDestinationSelected: (int index) {
        if (currentScreen.data == index) return;
        switch (index) {
          case 0:
            routerNotifier.pushAndRemoveUntil(Navigator.of(context), const HomeScreen());
            break;
          case 1:
            routerNotifier.push(Navigator.of(context), const CreatePersonScreen());
            break;
          case 2:
            break;
        }
      },
      destinations: <Widget>[
        NavigationDestination(icon: Icon(Icons.explore, color: theme.colorScheme.surface), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.add, color: theme.colorScheme.surface), label: 'Ajouter'),
        NavigationDestination(icon: Icon(Icons.settings, color: theme.colorScheme.surface), label: 'Options'),
      ],
    );
  }
}
