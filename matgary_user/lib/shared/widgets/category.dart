import 'package:flutter/material.dart';
import 'package:matgary_user/shared/widgets/sliding_bar.dart';

class CategoryWidget extends StatelessWidget {
   CategoryWidget(this.label,this.list);

final String label;
final List list;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CategHeaderLabel(
                    headerLabel: label.toUpperCase(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      crossAxisCount: 3,
                      children: List.generate(list.length - 1, (index) {
                        return SubcategPart(
                          mainCategName: label,
                          subCategName: list[index + 1],
                          assetName: 'images/label/label$index.jpg',
                          subcategLabel: list[index + 1],
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
           Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              maincategName: label,
            ),
          ),
        ],
      ),
    );
  }
}
