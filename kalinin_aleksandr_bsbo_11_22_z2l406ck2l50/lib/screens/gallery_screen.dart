import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<String> urls = [
    'https://images.pexels.com/photos/26100664/pexels-photo-26100664.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load',
    'https://images.pexels.com/photos/7654136/pexels-photo-7654136.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/24244035/pexels-photo-24244035.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/19400189/pexels-photo-19400189.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/12984738/pexels-photo-12984738.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  ];

  final PageController _pageController = PageController();

  void _goToPreviousPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Галерея изображений'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: urls.length,
            itemBuilder: (context, index) {
              return Center(
                child: Image.network(urls[index], fit: BoxFit.cover),
              );
            },
          ),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 2 - 25,
            child: IconButton(
              iconSize: 50,
              icon: Icon(Icons.arrow_back, color: Colors.cyan),
              onPressed: _goToPreviousPage,
            ),
          ),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height / 2 - 25,
            child: IconButton(
              iconSize: 50,
              icon: Icon(Icons.arrow_forward, color: Colors.cyan),
              onPressed: _goToNextPage,
            ),
          ),
        ],
      ),
    );
  }
}
