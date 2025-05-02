/// Structure of any data from providers used in this application.
abstract class ProviderValue<T> {
  final ProviderState state;
  final T data;
  ProviderValue({required this.state, required this.data});
}

/// Init : Default state of a provider value.
/// Loading : When provider value is working.
/// Success : When data has been fetched succefully.
/// Failure : When something from the app has catch an error known by developper (for example, a client input error).
/// Exception : Unknown error that has been catched (all error catched by try catch).
enum ProviderState { init, loading, success, failure, exception }
