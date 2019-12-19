//
//  SpAssembleViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/20.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "AssembleClassifications.h"
#import "ShareTools.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpAssembleViewController : SpBaseViewController
/** 标题数组 */
@property (nonatomic, copy)   NSArray<NSString *> *titlesArray;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIScrollView *pageScrollView;
/** 设置选中的下标 */
@property (nonatomic, assign) NSInteger gf_selectIndex;
@property (nonatomic, strong)AssembleClassifications *assembleModel;
@end

NS_ASSUME_NONNULL_END
