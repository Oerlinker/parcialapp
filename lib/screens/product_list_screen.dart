import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parcialapp/providers/cart_provider.dart';
import 'package:parcialapp/providers/product_provider.dart';
import 'package:parcialapp/models/product.dart';
import 'package:parcialapp/screens/cart_screen.dart';
import 'voice_cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      context.read<ProductProvider>().loadProducts();
      context.read<CartProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            tooltip: 'Agregar por voz',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VoiceCartScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, prov, _) {
          if (prov.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null) {
            return Center(child: Text('Error: ${prov.error}'));
          }
          if (prov.products.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }
          return ListView.builder(
            itemCount: prov.products.length,
            itemBuilder: (context, i) {
              final p = prov.products[i];
              return ListTile(
                title: Text(p.name),
                subtitle: Text(p.description),
                trailing: Text('\$${p.finalPrice.toStringAsFixed(2)}'),
                onTap: () {
                  context.read<CartProvider>().addProduct(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${p.name} agregado al carrito')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
