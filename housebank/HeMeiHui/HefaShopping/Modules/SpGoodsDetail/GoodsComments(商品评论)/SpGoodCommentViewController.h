//
//  SpGoodCommentViewController.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
// 商品评论
@interface SpGoodCommentViewController : SpBaseViewController

@property(nonatomic,copy)void(^myBlock)(UIViewController *vc);/*回调*/

@property (nonatomic, strong) NSString *productId;

@end

NS_ASSUME_NONNULL_END
