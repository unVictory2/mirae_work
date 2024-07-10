import 'package:flutter/material.dart';
import 'package:youtube_application_front/board.dart';

class VideoCard extends StatelessWidget {
  // final String image;
  // final String title;
  final BoardDTO board;
  const VideoCard({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    //String baseUrl = 'http://192.0.0.2:8080/';
    String baseUrl = 'http://192.168.123.106:8080/';

    return SizedBox(
      height: 320,
      child: Column(
        children: [
          Stack(
            children: [
              (board.imageUrls.isEmpty) ? 
              Image.asset('assets/images/0.webp', fit: BoxFit.cover, width: double.infinity, height: 240,) : // 이미지가 없을 경우 기본 이미지로 대체
              Image.network('$baseUrl${board.imageUrls[0]}', fit: BoxFit.cover, width: double.infinity, height: 240,),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(board.title , style: const TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/0.webp'),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(board.text, style: const TextStyle(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis,),
                      Text(board.userNickname, 
                        style: const TextStyle(color: Colors.grey, fontSize: 12),),                      
                    ],
                  )
                ),
                const SizedBox(width: 8),
                Expanded(                            
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 16.0,
                        icon: const Icon(Icons.more_vert),
                        onPressed: (){},
                        padding: const EdgeInsets.only(left: 8.0), // 왼쪽 패딩만 설정
                        constraints: const BoxConstraints(
                          minWidth: 16, // 최소 너비
                          minHeight: 16, // 최소 높이
                      ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }

}