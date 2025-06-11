// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:red_flags/presentation/router/router.notifier.dart';
// import 'package:red_flags/presentation/screens/search_screen/search_person_form.dart';
// import 'package:red_flags/presentation/viewmodels/simple_search_state.provider.dart';
// import 'package:red_flags/presentation/widgets/routing/slide_widget.dart';
// import 'package:red_flags/presentation/widgets/shakles/shakle_loading.dart';
// import 'package:red_flags/presentation/widgets/shakles/shakle_textfield.dart';
// import 'package:red_flags/presentation/widgets/shakles/shakle_outlined_button.dart';
// import 'package:red_flags/presentation/widgets/layouts/title_container.dart';
// import 'package:red_flags/core/l10n/app_localizations.dart';
// import 'package:red_flags/core/reactive/reactive_state.dart';
// import 'package:red_flags/core/themes/style_constant.dart';

// class SearchScreen extends ConsumerStatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   ConsumerState<SearchScreen> createState() => _State();
// }

// class _State extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
//   /// * For detailed seach.
//   final formState = SearchPersonFormState();

//   /// * For simple search.
//   String simpleInputValue = "";
//   Timer? _searchDelay;

//   @override
//   Widget build(BuildContext context) {
//     final simpleSeachState = ref.watch(simpleSearchStateProvider);

//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         ref.read(routerNotifierprovider.notifier).pop(Navigator.of(context));
//         return;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(screenGlobalMargin),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TitleContainer(
//                   title: AppLocalizations.of(context)!.searchScreenTitle,
//                   subtitle: AppLocalizations.of(context)!.searchScreenSubTitle,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 SizedBox(height: 60),
//                 SlideWidget(
//                   duration: Duration(milliseconds: 200),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                     child: ShakleTextfield(
//                       "Rechercher…",
//                       icon: Icons.person_outlined,
//                       onSubmitted: (value) {
//                         formState.updateValues(lastname: value);
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 60),
//                 Visibility(
//                   visible: simpleSeachState.status == DataStatus.loading,
//                   child: Padding(padding: EdgeInsets.only(top: 100), child: SizedBox(height: 40, width: 40, child: ShakleLoading())),
//                 ),
//                 Visibility(
//                   visible: simpleSeachState.status == DataStatus.success && simpleSeachState.persons.isEmpty,
//                   child: SlideWidget(
//                     duration: Duration(milliseconds: 400),
//                     child: Align(alignment: Alignment.center, child: Text("Not found")),
//                   ),
//                 ),
//                 Visibility(
//                   visible: simpleSeachState.status == DataStatus.failure,
//                   child: SlideWidget(
//                     duration: Duration(milliseconds: 400),
//                     child: Align(alignment: Alignment.center, child: Text("OUTCH")),
//                   ),
//                 ),
//                 Visibility(
//                   visible: simpleSeachState.persons.isNotEmpty,
//                   child: SlideWidget(
//                     duration: Duration(milliseconds: 400),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: ShakleOutlinedButton(
//                         onPressed: () {
//                           // GOTO screen list
//                         },
//                         AppLocalizations.of(context)!.searchButton,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(child: SizedBox()),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Called everytime value textfield from this widget is changed.
//   /// This function fetch persons given textfield values.
//   /// Allow me to know how many person can be find given the textfield values.
//   void _onTextfieldChange() {
//     _searchDelay?.cancel();
//     _searchDelay = Timer(Duration(milliseconds: 200), () async {});
//   }
// }
