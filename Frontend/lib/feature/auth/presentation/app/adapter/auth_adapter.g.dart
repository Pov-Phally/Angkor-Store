// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_adapter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthAdapter)
final authAdapterProvider = AuthAdapterFamily._();

final class AuthAdapterProvider
    extends $NotifierProvider<AuthAdapter, AuthState> {
  AuthAdapterProvider._({
    required AuthAdapterFamily super.from,
    required GlobalKey<State<StatefulWidget>>? super.argument,
  }) : super(
         retry: null,
         name: r'authAdapterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authAdapterHash();

  @override
  String toString() {
    return r'authAdapterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AuthAdapter create() => AuthAdapter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AuthAdapterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authAdapterHash() => r'464a4591b7ae608f5c542bf4246855074ed0b9c4';

final class AuthAdapterFamily extends $Family
    with
        $ClassFamilyOverride<
          AuthAdapter,
          AuthState,
          AuthState,
          AuthState,
          GlobalKey<State<StatefulWidget>>?
        > {
  AuthAdapterFamily._()
    : super(
        retry: null,
        name: r'authAdapterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AuthAdapterProvider call([GlobalKey<State<StatefulWidget>>? familyKey]) =>
      AuthAdapterProvider._(argument: familyKey, from: this);

  @override
  String toString() => r'authAdapterProvider';
}

abstract class _$AuthAdapter extends $Notifier<AuthState> {
  late final _$args = ref.$arg as GlobalKey<State<StatefulWidget>>?;
  GlobalKey<State<StatefulWidget>>? get familyKey => _$args;

  AuthState build([GlobalKey<State<StatefulWidget>>? familyKey]);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
