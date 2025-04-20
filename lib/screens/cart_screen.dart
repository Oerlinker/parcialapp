import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import './checkout_screen.dart';
import '../providers/recommendation_provider.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);


    context.read<CartProvider>().loadCart();
    context.read<RecommendationProvider>().loadRecommendations();
  }

  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {
      context.read<CartProvider>().loadCart();

      context.read<RecommendationProvider>().loadRecommendations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final recProv = context.watch<RecommendationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Carrito')),
      body: cart.loading
          ? const Center(child: CircularProgressIndicator())
          : cart.error != null
          ? Center(child: Text('Error: ${cart.error}'))
          : cart.items.isEmpty
          ? const Center(child: Text('Carrito vacío'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lista de ítems del carrito
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cart.decreaseQuantity(item.id),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cart.increaseQuantity(item.id),
                      ),
                    ],
                  ),
                  trailing: Text('\$${item.subtotal.toStringAsFixed(2)}'),
                  onLongPress: () => cart.removeItem(item.id),
                );
              },
            ),

            const Divider(),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Recomendaciones',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 180,
              child: recProv.loading
                  ? const Center(child: CircularProgressIndicator())
                  : recProv.error != null
                  ? Center(child: Text('Error: ${recProv.error}'))
                  : recProv.items.isEmpty
                  ? const Center(child: Text('No hay recomendaciones'))
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: recProv.items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final p = recProv.items[i];
                  return SizedBox(
                    width: 140,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {

                          context.read<CartProvider>().addProduct(p);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Agregado: ${p.name}')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    p.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${p.finalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${cart.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CheckoutScreen()),
                      );
                    },
                    child: const Text('Pagar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

