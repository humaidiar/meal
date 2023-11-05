import 'package:flutter/material.dart';
import 'package:meal/data/dummy_data.dart';
import 'package:meal/screens/categories.dart';
import 'package:meal/screens/filters.dart';
import 'package:meal/screens/meals.dart';
import 'package:meal/models/meal.dart';
import 'package:meal/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = []; // store the favorite meals
  Map<Filter, bool> _selectedFilter = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  };

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal); // return true

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meals is no longer a favorite');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as a favorite');
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result =
          await Navigator.of(context).push<Map<Filter, bool>>(MaterialPageRoute(
              builder: (ctx) => FilterScreen(
                    currentFilters: _selectedFilter,
                  )));
      setState(() {
        _selectedFilter = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilter[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilter[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilter[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilter[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = "Categories";

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      ); // store the favorite meals
      activePageTitle = "Favorites";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
