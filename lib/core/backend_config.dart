/// Datos de conexión al backend (Supabase Edge Functions). Se inyectan
/// en tiempo de compilación para no dejar URLs ni claves en el repo:
///
/// ```
/// flutter run --dart-define=SUPABASE_URL=https://<ref>.supabase.co \
///             --dart-define=SUPABASE_PUBLISHABLE_KEY=<clave>
/// ```
class BackendConfig {
  const BackendConfig({required this.supabaseUrl, required this.publishableKey});

  factory BackendConfig.fromEnvironment() => const BackendConfig(
    supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
    publishableKey: String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
  );

  final String supabaseUrl;
  final String publishableKey;

  /// Sin URL la app sigue funcionando, pero todo login cae al modo
  /// offline como si no hubiera red.
  bool get configurado => supabaseUrl.isNotEmpty;

  String get funcionUsuariosUrl => '$supabaseUrl/functions/v1/usuarios';
}
