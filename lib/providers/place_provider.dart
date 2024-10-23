import 'package:favorite_place_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceNotifer extends StateNotifier<List<Place>> {
  PlaceNotifer() : super([]);
  void addPlace(Place place) {
    state = [...state, place];
  }

  // List<Place> getPlaces() {
  //   return state;
  // }
}

final placeProvider = StateNotifierProvider<PlaceNotifer, List<Place>>(
  (ref) => PlaceNotifer(),
);
