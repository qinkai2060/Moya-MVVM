//
//  CollectShopTableViewCell.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN
/** 删除*/
typedef void(^deleteTableViewAction)(NSIndexPath *path,NSDictionary * userDic);
/** 滑动触发*/
typedef void(^sliderScrollviewAction)(void);
@interface CollectShopTableViewCell : UITableViewCell <JXViewProtocol>
/// 滑动视图
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, copy) deleteTableViewAction deleteAction;
@property (nonatomic, copy) sliderScrollviewAction sliderAction;
/** 判断是否被打开*/
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, assign) NSIndexPath *lastIndexPath;
@end

NS_ASSUME_NONNULL_END
