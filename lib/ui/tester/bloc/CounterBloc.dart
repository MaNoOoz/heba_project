/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'package:bloc/bloc.dart';

enum CounterEvents { increament, decrement }

class CounterBloc extends Bloc<CounterEvents, int> {
  @override
// TODO: implement initialState
  get initialState => 0;

  @override
  Stream<int> mapEventToState(CounterEvents event) async* {
    switch (event) {
      case CounterEvents.increament:
        yield state + 1;
        break;
      case CounterEvents.decrement:
        yield state - 1;
        break;
    }
  }
}
