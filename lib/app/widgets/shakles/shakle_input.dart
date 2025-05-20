import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:red_flags/core/themes/light_theme.dart';

class ShakleInput extends StatefulWidget {
  final String label;
  final List<String> autocompleteValues;
  final void Function(String) onChanged;

  const ShakleInput(this.label, {super.key, required this.onChanged, this.autocompleteValues = const []});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleInput> with TickerProviderStateMixin {
  /// This value allow me to know when input is selected. (And activate anim).
  final FocusNode _textfieldFocus = FocusNode();

  /// Shake Animation (for background color).
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 1_600);

  /// Shake Animation (for front input).
  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 1_000);

  /// Background color animation.
  late final AnimationController _colorController;
  late final Animation<Color?> _colorAnimation;
  final Duration _colorDurationTic = Duration(milliseconds: 10_000);

  /// Current state of input. Allow me to know when I have to activate or not the animation.
  final TextEditingController _textFieldController = TextEditingController();
  bool isFocus = false;

  /// Link between my overlay (autocomplete widget) and my TextField.
  final LayerLink _layerLink = LayerLink();

  /// Adress to my overlay (autocomplete widget).
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    /// * Set the text shaky animation for background text. The anim is started or stoped depending of the input focus.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -1.0, end: 1.0).animate(_shakyController1);

    /// * Set the text shaky animation for frontend text. The anim is started or stoped depending of the input focus.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -0.5, end: 0.5).animate(_shakyController2);

    /// * Set the background color.
    _colorController = AnimationController(vsync: this, duration: _colorDurationTic);
    _colorAnimation = ColorTween(begin: lightColorScheme.primary, end: lightColorScheme.secondary).animate(_colorController);

    /// * Listen Input focus mode. Will start or stop the animation depending of the focus state of the input.
    _textfieldFocus.addListener(_onFocusUpdate);
  }

  @override
  void dispose() {
    /// * Remove the listener.
    _textfieldFocus.removeListener(_onFocusUpdate);

    /// * Dispose all controllers.
    _shakyController1.dispose();
    _shakyController2.dispose();
    _colorController.dispose();
    _textFieldController.dispose();

    /// * Hide the autocomplete list.
    _hideAutoComplete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// * If widget is focused, we build the autocomplete.
    /// * We still need to wait this widget to be builted before building the autocomplete widget to Textfield (that is not existing at this right moment)
    if (isFocus == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _refreshAutoComplete();
      });
    }

    return TapRegion(
      /// * When user is clicking this widget, the AutoComplete widget should display.
      onTapInside: (event) {
        _refreshAutoComplete();
      },
      child: Stack(
        children: [
          /// * This is my background color animation (text + line).
          Visibility(
            visible: isFocus,
            child: AnimatedBuilder(
              animation: _shakyController1,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakyAnimation1.value, _shakyAnimation1.value / 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _textFieldController.text.isEmpty ? widget.label : " ",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _colorAnimation.value),
                      ),
                      SizedBox(height: 10),
                      Container(height: 1, width: double.infinity, color: _colorAnimation.value),
                    ],
                  ),
                );
              },
            ),
          ),

          /// * This is my frontline color animation (text + line).
          AnimatedBuilder(
            animation: _shakyAnimation2,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakyAnimation2.value, _shakyAnimation2.value / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _textFieldController.text.isEmpty ? widget.label : "",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(height: 10),
                    Container(height: 1, width: double.infinity, color: Theme.of(context).colorScheme.outline),
                  ],
                ),
              );
            },
          ),

          /// * This is my textfield widget (encapsulate by a widget that I use to manage my autocomplete list).
          CompositedTransformTarget(
            link: _layerLink,
            child: TextField(
              controller: _textFieldController,
              focusNode: _textfieldFocus,
              onChanged: (value) {
                widget.onChanged(value);
              },
              style: Theme.of(context).textTheme.labelLarge,
              decoration: null,
            ),
          ),
        ],
      ),
    );
  }

  /// This function make the autocomplete appear when used.
  /// Can also be used when autocomplete data has been updated.
  /// The values used will depend of the current autocompleteValues and text set in the TextField.
  void _refreshAutoComplete() {
    /// * When there's no text in textfield, do not show any autocomplete box, hide it.
    if (_textFieldController.text.isEmpty || widget.autocompleteValues.isEmpty) {
      _hideAutoComplete();
      return;
    }

    /// * Check that _overlayEntry do not exists, if it exists, we destroy the old reference to autocomplete and create a new one with new data.
    if (_overlayEntry != null) {
      _hideAutoComplete();
    }

    /// * Display the 10 first autocomplete values filtered by controller.value text.
    final filteredValues =
        widget.autocompleteValues
            .where((value) {
              return value.toLowerCase().contains(_textFieldController.text.toLowerCase());
            })
            .take(6)
            .toList();

    /// * Render the text field autocomplete box.
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, 40.0),
            child: Material(
              elevation: 1.0,
              child: TapRegion(
                onTapOutside: (event) {
                  _hideAutoComplete();
                },
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: filteredValues.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredValues[index]),
                      onTap: () {
                        setState(() {
                          _textFieldController.text = filteredValues[index];
                          _hideAutoComplete();
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    /// * Now inject the widget onto the textfield widget.
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hide the autocomplete listview when used.
  void _hideAutoComplete() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Called each time the input text is activated, focused.
  void _onFocusUpdate() {
    setState(() => isFocus = _textfieldFocus.hasFocus);
    if (isFocus) {
      /// Run loop animation.
      _shakyController1.repeat(reverse: true);
      _shakyController2.repeat(reverse: true);
      // _colorController.repeat(reverse: true);
      return;
    }

    /// Revert and stop animation.
    _shakyController1.reverse();
    _shakyController2.reverse();
    // _colorController.stop();
  }
}
