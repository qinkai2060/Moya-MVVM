//
//  SpGoodParticularsViewController.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "SpGoodBaseViewController.h"
#import "SpGoodsDetailViewController.h"
#import "GoodsDetailModel.h"
#import "AssembleGoodbaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpGoodParticularsViewController : SpBaseViewController
/** 更改标题 */
@property (nonatomic , copy) void(^changeTitleBlock)(BOOL isChange);
@property (nonatomic, strong)WKWebView*webView;
@property (assign,nonatomic)  BOOL isChangFlag;
//@property (strong,nonatomic) SpGoodBaseViewController *spGoodBaseVC;
@property (strong,nonatomic) AssembleGoodbaseViewController *assembleGoodbaseVC;
@property (nonatomic, strong) GoodsDetailModel *detailModel;

-(void)resetDataView;

@end

NS_ASSUME_NONNULL_END
