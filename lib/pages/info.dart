import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/uutisydin/uutisydin_text.png', height: 25),
              SizedBox(height: 8),
              const Text('Versio 1.0.0'),
              SizedBox(height: 20),

              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi '
                'ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit '
                'in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
                'occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim '
                'id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Vivamus luctus urna sed urna ultricies ac tempor dui sagittis. In condimentum facilisis porta. '
                'Sed nec diam eu diam mattis viverra. Nulla fringilla, orci ac euismod semper, magna diam porttitor mauris.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
