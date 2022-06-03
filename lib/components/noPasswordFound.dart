import 'package:flutter/material.dart';

class NoPasswordFound extends StatelessWidget {
  const NoPasswordFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: (mediaQuery.size.height -
              AppBar().preferredSize.height -
              mediaQuery.padding.bottom) *
          0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_cell,
            size: 250,
            color: Colors.grey.withAlpha(180),
          ),
          Text(
            'No passwords available',
            style: TextStyle(
              color: Colors.grey.withAlpha(200),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
