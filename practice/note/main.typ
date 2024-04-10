#import "template.typ": *

#show: template.with(
  title: [algorithm-journey],
  short_title: "algorithm-journey",
  description: [
    算法学习.
  ],
  date: datetime(year: 2024, month: 4, day: 3),
  authors: (
    (
      name: "0x1B05",
      github: "https://github.com/0x1B05",
      homepage: "https://github.com/0x1B05", // 个人主页
      affiliations: "1",
    ),
  ),
  affiliations: (
    (id: "1", name: "NUFE"),
  ),

  paper_size: "a4",
  text_font: "Linux Libertine",
  sc_font: "Noto Sans CJK SC",
  code_font: "DejaVu Sans Mono",
  
  // 主题色
  accent: orange,
  // 封面背景图片
  cover_image: "./figures/Pine_Tree.jpg", // 图片路径或 none
  // 正文背景颜色
  // background_color: "#FAF9DE" // HEX 颜色或 none
)

#include "content/预备知识.typ"
#include "content/排序.typ"
#include "content/二分查找.typ"
#include "content/同余原理.typ"
#include "content/快速幂.typ"
#include "content/前缀信息.typ"
#include "content/KMP.typ"
#include "content/Manacher.typ"

#include "content/堆结构.typ"
#include "content/二叉树.typ"
#include "content/Morris遍历.typ"
#include "content/图.typ"
#include "content/链表.typ"
#include "content/并查集.typ"
#include "content/滑动窗口.typ"
#include "content/有序表.typ"

#include "content/经典递归流程.typ"
#include "content/动态规划.typ"
#include "content/哈希表和哈希函数.typ"
#include "content/贪心.typ"

#include "content/杂题.typ"
