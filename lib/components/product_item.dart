import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loja/exceptions/http_exception.dart';
import 'package:loja/models/product.dart';
import 'package:loja/models/product_list.dart';
import 'package:loja/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(
    this.product, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.productForm,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Deseja realmente fazer isso?'),
                    content: const Text(
                        'Gostaria de excluir esse produto do carrinho?'),
                    actions: [
                      TextButton(
                        child: const Text('Não quero excluir'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      TextButton(
                        child: const Text('Quero excluir'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                ).then(
                  (value) async {
                    if (value ?? false) {
                      try {
                        await Provider.of<ProductList>(
                          context,
                          listen: false,
                        ).removeProduct(product);
                      } on HttpException catch (error) {
                        msg.showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
