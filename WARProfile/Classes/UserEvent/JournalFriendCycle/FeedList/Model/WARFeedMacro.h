//
//  WARFeedMacro.h
//  Pods
//
//  Created by 卧岚科技 on 2018/6/20.
//

#ifndef WARFeedMacro_h
#define WARFeedMacro_h

// cell 与屏幕间距
#define kCellContentMargin 11.5
// 头像宽高
#define kUserImageWidthHeight 42
// 头像与右边内容间距
#define kUserImageContentMargin 10
// 内容与屏幕左间距
#define kFeedMainContentLeftMargin (kCellContentMargin + kUserImageWidthHeight + kUserImageContentMargin)
// 内容宽度缩放比
#define kContentScale (300.0/349.0)
//#define kContentScale ((kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin - 13) / 345.0)
// 多页高度
#define kFeedMultilPageViewHeight (481)
// 单页最大高度
#define kFeedPageViewMaxHeight (481)
// 内容高度按比例缩放
#define kFeedMainContentViewHeight (kFeedMultilPageViewHeight * kContentScale + 40 + 20) //内容高度481,滑块40，内容上下间距10+10
//图片内容与文本内容宽度比
#define kImageTextScale 1
//#define kImageTextScale (247.0/300.0)

//feedcell 内的内容要有一个左边间距
#define kContentLeftMargin   5

#define kLinkContentScale (300.0/349.0)
#define kLinkFontSize(value) ((value) * kLinkContentScale)

#define kFeedNumber(value) ((value) * (300.0/349.0))
#define kFeedFontSize(value) ((value) * kLinkContentScale)

#define  kKeyWindow        [UIApplication sharedApplication].keyWindow

#endif /* WARFeedMacro_h */
