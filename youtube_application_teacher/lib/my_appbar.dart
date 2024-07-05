import 'package:flutter/material.dart';

class MyAppbar extends AppBar {
  MyAppbar.withValue (
    {
      super.key,
      required String title,
      required List<Icon> actions,
      required Icon leading, // 앞 쪽에 나오는 걸 leading이라고 많이 표현 
    }
  ) : super(
    backgroundColor: Colors.black,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row( // AppBar의 앞부분. 홈 아이콘, 타이틀
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading, // 홈아이콘.
            const SizedBox(width : 10),
            Text(title, 
            style: const TextStyle (
              color: Colors.white,
              fontSize:20
              ),
            ), // 타이틀. leading과 title 둘 다 withValue 생성자에서 입력 받음.
          ],
        ),
        Row( // AppBar의 뒷부분, 액션아이콘들, withValue() 생성자에서 받음
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children : [
            IconButton(
              icon: actions[0],
              color : Colors.white,
              onPressed: () {},
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: actions[1],
              color : Colors.white,
              onPressed: () {},
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: actions[2],
              color : Colors.white,
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  );
}