import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal/models/meal.dart';

//storing the favorite meals into provider using StateNotifier
class FavoriteMealNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state
          .where((m) => m.id != meal.id)
          .toList(); // removing the meal favorite
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

//export the provider
final favoriteMealProvider =
    StateNotifierProvider<FavoriteMealNotifier, List<Meal>>((ref) {
  return FavoriteMealNotifier();
});
