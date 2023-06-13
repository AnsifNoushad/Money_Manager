import 'package:flutter/material.dart';

import 'package:money_manager/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/screens/category/category_add_popup.dart';
import 'package:money_manager/screens/category/screen_category.dart';
import 'package:money_manager/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager/screens/trensactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  static ValueNotifier<int> seletedIndexNotifier = ValueNotifier(0);

  final _pages = [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 238, 233, 233),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: seletedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          if (seletedIndexNotifier.value == 0) {
            print('add transaction');
            Navigator.of(context).pushNamed(ScreenaddTransaction.routeName);
          } else {
            print('Add Category');

            showCategoryAddPopup(context);
            // print('Add Category');
            // final _sample = CategoryModel(
            //   id: DateTime.now().millisecondsSinceEpoch.toString(),
            //   name: 'Travel',
            //   type: CategoryType.expense,
            // );

            // CategoryDB().inserCategory(_sample);
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
          weight: 20,
          size: 30,
        ),
      ),
    );
  }
}
