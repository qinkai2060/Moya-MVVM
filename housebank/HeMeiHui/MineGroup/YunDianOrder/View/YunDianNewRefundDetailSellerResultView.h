//
//  YunDianNewRefundDetailSellerResultView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianNewRefundDetailModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol YunDianNewRefundDetailSellerResultViewDelegate <NSObject>

-(void)yunDianNewRefundDetailSellerResultViewDelegateClickImgIndex:(NSInteger)index;

@end
@interface YunDianNewRefundDetailSellerResultView : UIView
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel * sellerResultLable;
@property (nonatomic, strong) UILabel * timeLable;
@property (nonatomic, strong) UILabel * sellerDetailLable;
@property (nonatomic, strong) YunDianNewRefundDetailModel *refundDetailModel;
+ (CGFloat)yunDianNewRefundDetailSellerResultViewReturnHeight:(YunDianNewRefundDetailModel *)refundDetailModel;
@property (nonatomic, weak) id <YunDianNewRefundDetailSellerResultViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
