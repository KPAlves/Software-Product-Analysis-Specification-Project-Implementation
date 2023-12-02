import 'package:flutter/material.dart';
import 'package:personal_trainer/theme/colors.dart';

// TODO: alterar nomenclaturas
class MenuScreen extends StatefulWidget {
  final Category currentCategory;
  final ValueChanged<Category> onCategoryTap;
  final ValueChanged<Text> onMenuTap;

  const MenuScreen({
    Key? key,
    required this.currentCategory,
    required this.onCategoryTap, 
    required this.onMenuTap,    
  }) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Category> _categories = Category.values;

  Widget _buildMenu(Category category, BuildContext context)  {
    final categoryString = 
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () { 
        widget.onCategoryTap(category);
        widget.onMenuTap(Text(categoryString));
      },
      child: category == widget.currentCategory 
            ? Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text(
                  categoryString,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14.0),
                Container(
                  width: 70.0,
                  height: 2.0,
                  color: pink400,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                categoryString,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: brown900.withAlpha(153),
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 40.0),
        color: pink100,
        child: ListView(
            children: _categories
                .map((Category c) => _buildMenu(c, context))
                .toList()),
      ),
    );
  }
}

//TODO: resolver 

enum Category {
  planilha,
  usuarios,
  exercicios,
  perfis,
}