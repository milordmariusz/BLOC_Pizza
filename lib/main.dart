import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_bloc/bloc/pizza_bloc.dart';

import 'models/pizza_model.dart';

Random random = Random();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => PizzaBloc()..add(LoadPizzaCounter()))
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'The Pizza Bloc',
          home: HomeScreen(),
        ));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Pizza Bloc'),
        centerTitle: true,
        backgroundColor: Colors.orange[800],
      ),
      body: Center(
          child: BlocBuilder<PizzaBloc, PizzaState>(builder: (context, state) {
        if (state is PizzaInitial) {
          return const CircularProgressIndicator(color: Colors.orange);
        }
        if (state is PizzaLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${state.pizzas.length}',
                style:
                    const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    for (int index = 0; index < state.pizzas.length; index++)
                      Positioned(
                          left: random.nextInt(250).toDouble(),
                          top: random.nextInt(400).toDouble(),
                          child: SizedBox(
                              height: 150,
                              width: 150,
                              child: state.pizzas[index].image))
                  ],
                ),
              )
            ],
          );
        } else {
          return const Text('Something went wrong!');
        }
      })),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: const Icon(Icons.local_pizza_outlined),
              backgroundColor: Colors.orange[800],
              onPressed: () {
                context.read<PizzaBloc>().add(AddPizza(Pizza.pizzas[0]));
              }),
          const SizedBox(height: 10),
          FloatingActionButton(
              child: const Icon(Icons.remove),
              backgroundColor: Colors.orange[800],
              onPressed: () {
                context.read<PizzaBloc>().add(RemovePizza(Pizza.pizzas[0]));
              }),
          const SizedBox(height: 10),
          FloatingActionButton(
              child: const Icon(Icons.local_pizza_outlined),
              backgroundColor: Colors.orange[500],
              onPressed: () {
                context.read<PizzaBloc>().add(AddPizza(Pizza.pizzas[1]));
              }),
          const SizedBox(height: 10),
          FloatingActionButton(
              child: const Icon(Icons.remove),
              backgroundColor: Colors.orange[500],
              onPressed: () {
                context.read<PizzaBloc>().add(RemovePizza(Pizza.pizzas[1]));
              }),
        ],
      ),
    );
  }
}
