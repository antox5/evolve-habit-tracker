
import 'package:flutter_application_3/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartonCubit extends Cubit<List<Item>> {
  CartonCubit() : super([]); // Initialize with an empty list of items

  // ignore: empty_constructor_bodies
  void addItem(Item item) {
    final updatedList = List<Item>.from(state);
    updatedList.add(item);
    emit(updatedList);
  }

  void removeItem(Item item) {
    final updatedList = List<Item>.from(state);
    updatedList.remove(item);
    emit(updatedList);
  }
}