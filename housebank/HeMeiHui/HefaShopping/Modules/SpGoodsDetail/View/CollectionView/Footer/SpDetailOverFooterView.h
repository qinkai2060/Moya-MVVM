//
//  SpDetailOverFooterView.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpGoodParticularsViewController.h"
#import "GoodsDetailModel.h"

typedef void(^SpDetailOverFooterWKWebViewScrollViewBlock)();
typedef void(^SpDetailOverFooterWKWebViewScrollViewFinshBlock)(CGFloat height);

@interface SpDetailOverFooterView : UICollectionReusableView
@property (nonatomic, copy) SpDetailOverFooterWKWebViewScrollViewBlock wkWebViewScrollViewBlock;
@property (nonatomic, copy) SpDetailOverFooterWKWebViewScrollViewFinshBlock wkWebViewScrollViewFinshBlock;
@property (nonatomic, strong) WKWebView*webView;
@property (nonatomic, strong) GoodsDetailModel *detailModel;

@end
