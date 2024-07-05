import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const ContentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Column(
        children: [
          Stack( // 스택 사용 이유 : 영상 뒤에 배경이 있고, 그 위에 이미지나 제목이 얹혀진 형태를 만들기 위해서. 아니면 이미지 위에 텍스트 올라오게 응요도 할 수 있다. 위젯끼리 레이어 해서 쓸 수 있게 해줌.
            children: [
              Image.asset(image, fit : BoxFit.cover, width: double.infinity,), // 너비는 꽉 채워서
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(title, style: TextStyle(color: Colors.white, fontSize: 12),),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row( // 개별 영상의 아이콘, 제목, 점3개 부분
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [ 
                Column( // 텍스트와 아이콘 배치가 이상해지기 때문에 column 넣어서 정렬. 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(image),
                    ),
                  ],
                ),
                const SizedBox(width: 8,),
                Expanded( // flex 쓰기 위해 expanded로
                  flex: 12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // maxLines : 문장 길어지면 자연스럽게 2줄로 줄바꿈.
                      // TextOverflow.ellipsis : 텍스트가 너무 긴 경우 ...으로 생략하면서 잘라줌
                      Text(title, style: const TextStyle(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey),),
                    ],
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded( // 점 3개 아이콘
                  flex: 1,
                  child: IconButton( // 점 3개 아이콘 위치가 애매할거임, column으로 감싸서 위쪽배치. 버튼 크기도 너무 클거임. 
                    icon : const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}