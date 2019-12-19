//
//  VipPlayDetailBottomView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^callBackBlock)(void);
@interface VipPlayDetailBottomView : UIView
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIImageView * bottomImage;
@property (nonatomic, strong) UILabel * bottomLabel;
@property (nonatomic, strong) UILabel * nowPriceLabel;
@property (nonatomic, strong) UILabel * beforePriceLabel;
@property (nonatomic, strong) UIButton * buyBtn;
@property (nonatomic, copy) callBackBlock block;
- (void)setUpDetailUIWtihDic:(NSDictionary *)dic withBlock:(callBackBlock)block;

@end

NS_ASSUME_NONNULL_END
