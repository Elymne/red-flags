/// This class represent what should be returned from all my providers.
/// The data state can have 4 values depending of the actions.
/// This doc sucks.
abstract class ProviderValue<T> {
  final ProviderState state;
  final T value;
  ProviderValue({required this.state, required this.value});
}

enum ProviderState { init, loading, success, failure }
