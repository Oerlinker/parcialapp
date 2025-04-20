import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parcialapp/providers/cart_provider.dart';
import 'package:parcialapp/providers/product_provider.dart';
import 'package:parcialapp/models/product.dart';
import 'package:parcialapp/screens/cart_screen.dart';
import 'voice_cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = '';
  bool _isSearchVisible = false;

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
        title: _isSearchVisible ? _buildSearchField() : const Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            tooltip: _isSearchVisible ? 'Cerrar búsqueda' : 'Buscar producto',
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchQuery = '';
                }
              });
            },
          ),
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

          final filteredProducts =
              prov.products
                  .where(
                    (p) => p.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();

          if (filteredProducts.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }

          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, i) {
              final p = filteredProducts[i];
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

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Buscar producto...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 18),
      onChanged: (query) {
        setState(() {
          _searchQuery = query;
        });
      },
    );
  }
}
