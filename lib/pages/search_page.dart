import 'package:cookin/apis/mealdb_api.dart';
import 'package:cookin/apis/recipe_reps.dart';
import 'package:cookin/models/category_model.dart';
import 'package:cookin/models/item_model.dart';
import 'package:cookin/pages/recipe_page.dart';
import 'package:cookin/utils/colors.dart';
import 'package:cookin/utils/navigatio_bar.dart';
import 'package:cookin/widget/card.dart';
import 'package:cookin/widget/category.dart';
import 'package:cookin/widget/searchbar.dart';
import 'package:flutter/material.dart';
import '../widget/modal.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.value,
  });

  final String value;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
             color: AppColors.textColor,
          ),
          onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const BottonNavBar(),));
          },
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: SearchBarFood(
                            hintText: widget.value,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        const Flexible(
                          flex: 1,
                          child: FilterModal(),
                        ),
                      ],
                    ),
                  ),
                  const Categories2(),
                ],
              ),
            ),
          ];
        },
        body: FutureBuilder<ItemModel>(
          future: RecipesRepository().searchMeals(widget.value),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Meals> index = snapshot.data!.meals;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Set the number of columns here
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                ),
                itemCount: index.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipePage(
                                mealId: int.parse(
                                    snapshot.data!.meals[index].idMeal),
                                repository: RecipesRepository())),
                      );
                    },
                    child: Flexible(
                      flex: 5,
                      child: FoodCard2(
                        title: snapshot.data!.meals[index].strMeal,
                        thumbnailUrl: snapshot.data!.meals[index].strMealThumb,
                      ),
                    ),
                  );
                },
                                  ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}',
              style: const TextStyle(
                color: AppColors.warning,
              ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
          
        ),
        
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryPage extends StatefulWidget {
  CategoryPage({
    super.key,
    required this.value,
  });

  late String value;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    if (widget.value == 'All') {
      widget.value = 'Miscellaneous';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
             color: AppColors.textColor,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BottonNavBar(),));
          },
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: SearchBarFood(
                            hintText: widget.value,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        const Flexible(
                          flex: 1,
                          child: FilterModal(),
                        ),
                      ],
                    ),
                  ),
                  const Categories2(),
                ],
              ),
            ),
          ];
        },
        body: FutureBuilder<List<MealsByCategorie>>(
          future: MealsApi.GetMealByCategory(widget.value),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Set the number of columns here
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipePage(
                              mealId: int.parse(
                                  snapshot.data![index].idMeal.toString()),
                              repository: RecipesRepository(),
                            ),
                          ),
                        );
                      },
                      child: Flexible(
                        child: FoodCard2(
                          title: snapshot.data![index].strMeal.toString(),
                          thumbnailUrl:
                              snapshot.data![index].strMealThumb.toString(),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
             return Text('${snapshot.error}',
            style: const TextStyle(
              color: AppColors.textColor
            ),
            );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
