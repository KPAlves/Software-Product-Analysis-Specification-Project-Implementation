import 'package:flutter/material.dart';
import 'package:personal_trainer/screens/exercise_screen.dart';
import 'package:personal_trainer/screens/list_user_screen.dart';
import 'package:personal_trainer/screens/menu_screen.dart';
import 'package:personal_trainer/screens/perfil_acesso_screen.dart';

class HomeScreen extends StatelessWidget {
  final Category category;

  const HomeScreen({this.category = Category.usuarios, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (category == Category.exercicios) {
      return const ExerciseScreen();
    } 
    else if (category == Category.usuarios) {
      return const ListUserScreen();
    }
    else if (category == Category.perfis) {
      return const PerfilAcessoScreen();
    } 
    else if (category == Category.planilha) {
      return AsymmetricView(products: ProductsRepository.loadProducts(category));
    }    
    else {
      return AsymmetricView(products: ProductsRepository.loadProducts(category));
    }
  }
}

class Product {
  const Product({
    required this.category,
    required this.id,
    required this.name,
    required this.image,
    required this.descricao,
  });

  final Category category;
  final int id;
  final String name;
  final String image;
  final String descricao;

  @override
  String toString() => "$name (id=$id)";
}


class ProductsRepository {
  static List<Product> loadProducts(Category category) {
    const allProducts = <Product>[
      Product(
        category: Category.usuarios,
        id: 0,
        name: 'Esteira',
        descricao: '10 minutos corrida',
        image: 'assets/images/esteira.png',
      ),
      Product(
        category: Category.usuarios,
        id: 1,
        name: 'Flexão',
        descricao: '4 séries x 15 repetições',
        image: 'assets/images/flexao.png',
      ),
      Product(
        category: Category.usuarios,
        id: 2,
        name: 'Triceps polia',
        descricao: '4 séries x 10 repetições',
        image: 'assets/images/triceps_polia.png',
      ),              
      Product(
        category: Category.usuarios,
        id: 3,
        name: 'Abdominal',
        descricao: '4 séries x 20 repetições',
        image: 'assets/images/abdominal.png',
      ),      
    ];
    if (category == Category.planilha) {
      return allProducts;
    } else {
      return allProducts.where((Product p) {
        return p.category == category;
      }).toList();
    }
  }
}

class AsymmetricView extends StatelessWidget {
  final List<Product> products;

  const AsymmetricView({Key? key, required this.products}) : super(key: key);

  List<Widget> _buildColumns(BuildContext context) {
    if (products.isEmpty) {
      return <Container>[];
    }

    //TODO: provavelmente excluir
    
    /// This will return a list of columns. It will oscillate between the two
    /// kinds of columns. Even cases of the index (0, 2, 4, etc) will be
    /// TwoProductCardColumn and the odd cases will be OneProductCardColumn.
    ///
    /// Each pair of columns will advance us 3 products forward (2 + 1). That's
    /// some kinda awkward math so we use _evenCasesIndex and _oddCasesIndex as
    /// helpers for creating the index of the product list that will correspond
    /// to the index of the list of columns.
    return List.generate(_listItemCount(products.length), (int index) {
      double width = .59 * MediaQuery.of(context).size.width;
      Widget column;
        /// Even cases
        int bottom = _evenCasesIndex(index);
        column = TwoProductCardColumn(
            bottom: products[bottom],
            top: products.length - 1 >= bottom + 1
                ? products[bottom + 1]
                : null);
        width += 32.0;

      return SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: column,
        ),
      );
    }).toList();
  }

  int _evenCasesIndex(int input) {
    /// The operator ~/ is a cool one. It's the truncating division operator. It
    /// divides the number and if there's a remainder / decimal, it cuts it off.
    /// This is like dividing and then casting the result to int. Also, it's
    /// functionally equivalent to floor() in this case.
    return input ~/ 2 * 3;
  }

  int _oddCasesIndex(int input) {
    assert(input > 0);
    return (input / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    if (totalItems % 3 == 0) {
      return totalItems ~/ 3 * 2;
    } else {
      return (totalItems / 3).ceil() * 2 - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(0.0, 34.0, 16.0, 44.0),
      children: _buildColumns(context),
    );
  }
}

class TwoProductCardColumn extends StatelessWidget {
  const TwoProductCardColumn({
    required this.bottom,
    this.top,
    Key? key,
  }) : super(key: key);

  final Product bottom;
  final Product? top;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      const spacerHeight = 44.0;

      double heightOfCards = (constraints.biggest.height - spacerHeight) / 2.0;
      double heightOfImages = heightOfCards - ProductCard.kTextBoxHeight;
      double imageAspectRatio = heightOfImages >= 0.0
          ? constraints.biggest.width / heightOfImages
          : 49.0 / 33.0;

      return ListView(
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 0.0),
                child: SizedBox(
                    height: spacerHeight,
                  ),            
            // child: top != null
                // ? ProductCard(
                //     imageAspectRatio: imageAspectRatio,
                //     product: top!,
                //   )
                // : SizedBox(
                //     height: heightOfCards > 0 ? heightOfCards : spacerHeight,
                //   ),       
          ),
          const SizedBox(height: spacerHeight),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 0.0),
            child: ProductCard(
              imageAspectRatio: imageAspectRatio,
              product: bottom,
            ),
          ),
        ],
      );
    });
  }
}

class OneProductCardColumn extends StatelessWidget {
  const OneProductCardColumn({required this.product, Key? key})
      : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 550,
          ),
          child: ProductCard(
            product: product,
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard(
      {this.imageAspectRatio = 33 / 49, required this.product, Key? key})
      : assert(imageAspectRatio > 0),
        super(key: key);

  final double imageAspectRatio;
  final Product product;

  static const kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final imageWidget = Image.asset(
      product.image,
      fit: BoxFit.cover,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: imageAspectRatio,
          child: imageWidget,
        ),
        SizedBox(
          height: kTextBoxHeight * MediaQuery.of(context).textScaleFactor,
          width: 121.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                product.name,
                style: theme.textTheme.labelLarge,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4.0),
              Text(
                product.descricao,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

