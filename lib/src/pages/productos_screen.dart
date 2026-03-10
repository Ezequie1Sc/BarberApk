import 'package:flutter/material.dart';

class ProductoScreen extends StatelessWidget {
  const ProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample product data (replace with your actual products)
    final List<Map<String, dynamic>> products = [
      {
        'name': 'Cera para Cabello',
        'price': 15.99,
        'image': 'assets/pomada.jpg',
        'description': 'Cera de fijación fuerte para estilos duraderos.',
      },
      {
        'name': 'Aceite para Barba',
        'price': 12.50,
        'image': 'assets/aceite.jpg',
        'description': 'Aceite nutritivo para una barba suave y brillante.',
      },
      {
        'name': 'Shampoo Anticaída',
        'price': 18.75,
        'image': 'assets/shampoo.jpg',
        'description': 'Shampoo fortificante para cabello más fuerte.',
      },
      {
        'name': 'Crema de Afeitar',
        'price': 10.99,
        'image': 'assets/pomada.jpg',
        'description': 'Crema suave para un afeitado cómodo.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Productos',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Large products icon with animation
            const Icon(
              Icons.spa,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 20),
            const Text(
              'Nuestros Productos Premium',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Descubre nuestra exclusiva línea de cuidado personal, SOLICTALO EN CAJA',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: const Color(0xFF252525),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Colors.amber,
                      width: 1,
                    ),
                  ),
                  elevation: 4,
                  shadowColor: Colors.amber.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(0.7),
                            child: Image.asset(
                              product['image'],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.face_retouching_natural,
                                  size: 60,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product['description'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product['price'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Todos nuestros productos están elaborados con ingredientes naturales y de la más alta calidad.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}