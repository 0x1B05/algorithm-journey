#import "template.typ": *

#show: template.with(
  title: [algorithm-journey],
  short-title: "algorithm-journey",
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

  paper-size: "a4",
  fonts: (
    (
      en-font: "Libertinus Serif",
      zh-font: "Noto Sans CJK SC",
      code-font: "DejaVu Sans Mono",
    )
  ),
  
  // 主题色
  accent: orange,
  // 封面背景图片
  cover-image: "./figures/Pine_Tree.jpg", // 图片路径或 none
  // 正文背景颜色
  // background_color: "#FAF9DE" // HEX 颜色或 none
)

#include "content/真题.typ"
#include "content/模板.typ"
#include "content/刷题清单.typ"
