import 'package:flutter/material.dart';

class ButtonHorizRail extends StatelessWidget {
  

  const ButtonHorizRail({
    super.key,
    required this.items, 
    this.spacing=4.0,
  });

  final List<String> items; // 버튼들 사이의 간격
  final double? spacing; // 버튼들 사이의 간격

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // 버튼 안 보이는 거 방지
      scrollDirection: Axis.horizontal,      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 스트링 리스트를 입력으로 받아 index 이용해 버튼들을 수평 방향 리스트 아이템으로 생성
          ...List.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                onPressed: (){ (index, context) => _onPressed(index, context); },                
                style: const ButtonStyle(
                    shape: WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)), // 버튼의 모서리를 둥글게 만듦
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 30, 30, 30)),                          
                ),
                child: Text(items[index], style: const TextStyle(color: Colors.white, fontSize: 12), // 버튼 내부의 텍스트 형식
              ),
            ));
          }),
        ].expand((element) => [ SizedBox(width: spacing), element, ]).toList(),
      ),
    );
  }

  void _onPressed(int index, BuildContext context) {
    // print('Button $index pressed');
    SnackBar snackBar = SnackBar(content: Text('Button $index pressed'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => items[index]);
  }
}