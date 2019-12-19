//
//  YunDianNewRefundDetailBugerResultView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianNewRefundDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YunDianNewRefundDetailBugerResultViewTypeClick) {
    YunDianNewRefundDetailBugerResultViewTypeRefund,//退款
    YunDianNewRefundDetailBugerResultViewTypeRefuse,//拒绝
};
@protocol YunDianNewRefundDetailBugerResultViewDelegate <NSObject>

- (void)yunDianNewRefundDetailBugerResultViewSeller_Confirm_RefundDelegate:(YunDianNewRefundDetailBugerResultViewTypeClick)type;
-(void)yunDianNewRefundDetailBugerResultViewDelegateClickImgIndex:(NSInteger)index;

@end


@interface YunDianNewRefundDetailBugerResultView : UIView
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel * buyerResultLable;
@property (nonatomic, strong) UILabel * timeLable;
@property (nonatomic, strong) UILabel * buyerDetailLable;
@property (nonatomic, strong) UIView *viewButton;
@property (nonatomic, strong) UIView *viewImage;
@property (nonatomic, strong) UIButton * btnRefuse;
@property (nonatomic, strong) UIButton * btnAgree;
@property (nonatomic, strong) YunDianNewRefundDetailModel *refundDetailModel;
+ (CGFloat)yunDianNewRefundDetailSellerResultViewReturnHeight:(YunDianNewRefundDetailModel *)refundDetailModel;
@property (nonatomic, weak) id <YunDianNewRefundDetailBugerResultViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
