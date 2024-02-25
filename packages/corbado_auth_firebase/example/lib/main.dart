import 'package:corbado_auth_firebase/corbado_auth_firebase.dart';
import 'package:example/auth_provider.dart';
import 'package:example/firebase_options.dart';
import 'package:example/pages/loading_page.dart';
import 'package:example/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(name: 'corbado_auth_example', options: DefaultFirebaseOptions.currentPlatform);

  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  // This is a nice pattern if you need to initialize some of your services
  // before the app starts.
  // As we are using riverpod this initialization happens inside providers.
  // First we show a loading page.
  runApp(const LoadingPage());

  // Now we do the initialization.
  final corbadoAuth = CorbadoAuthFirebase();
  await corbadoAuth.init('us-central1');

  // Finally we override the providers that needed initialization.
  // Now the real app can be loaded.
  runApp(ProviderScope(
    overrides: [
      corbadoAuthProvider.overrideWithValue(corbadoAuth),
    ],
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF1953ff),
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Color(0xFF1953ff),
          error: Colors.redAccent,
          onError: Colors.white,
          background: Color(0xFF1953ff),
          onBackground: Colors.white,
          surface: Color(0xFF1953ff),
          onSurface: Color(0xFF1953ff),
        ),
      ),
    );
  }
}
