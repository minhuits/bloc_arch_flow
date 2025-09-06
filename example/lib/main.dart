import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final environment = CounterEnvironment();

    return MaterialApp(
      title: 'Bloc MVI Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CounterMviBloc(environment)),
          BlocProvider(create: (_) => CounterTcaBloc(environment)),
        ],
        child: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  void initState() {
    super.initState();
    context.read<CounterMviBloc>().mviEffects.listen((effect) {
      if (!context.mounted) return;

      switch (effect) {
        case ShowToast():
          (data) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data.message)));
          };
        case NavigateTo():
          (data) {
            debugPrint('Navigating to: ${data.route}');
          };
        case PlaySound():
          (data) {
            debugPrint('Playing sound: ${data.soundAsset}');
          };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc MVI TCA Mixin Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<CounterMviBloc, CounterState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const Text('MVI Counter:', style: TextStyle(fontSize: 20)),
                    Text('${state.count}', style: Theme.of(context).textTheme.headlineMedium),
                    if (state.isLoading) const CircularProgressIndicator(),
                    if (state.error != null)
                      Text('Error: ${state.error}', style: const TextStyle(color: Colors.red)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CounterMviBloc>().add(const CounterIntent.decrement()),
                          child: const Text('-'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CounterMviBloc>().add(const CounterIntent.increment()),
                          child: const Text('+'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context.read<CounterMviBloc>().add(
                                  const CounterIntent.incrementAsync(),
                                ),
                          child: const Text('Async +'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CounterMviBloc>().add(const CounterIntent.reset()),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 50),
            BlocBuilder<CounterTcaBloc, CounterState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const Text('TCA Counter:', style: TextStyle(fontSize: 20)),
                    Text('${state.count}', style: Theme.of(context).textTheme.headlineMedium),
                    if (state.isLoading) const CircularProgressIndicator(),
                    if (state.error != null)
                      Text('Error: ${state.error}', style: const TextStyle(color: Colors.red)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CounterTcaBloc>().add(const CounterActions.decrement()),
                          child: const Text('-'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CounterTcaBloc>().add(const CounterActions.increment()),
                          child: const Text('+'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context.read<CounterTcaBloc>().add(
                                  const CounterActions.incrementAsync(),
                                ),
                          child: const Text('Async +'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CounterTcaBloc>().add(const CounterActions.reset()),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}