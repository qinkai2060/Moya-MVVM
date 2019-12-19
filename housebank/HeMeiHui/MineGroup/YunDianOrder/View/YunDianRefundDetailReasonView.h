//
//  YunDianRefundDetailReasonView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianRefundDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YunDianRefundDetailReasonViewDelegate <NSObject>

- (void)yunDianRefundDetailReasonViewDelegateClickImgIndex:(NSInteger)index;

@end

@interface YunDianRefundDetailReasonView : UIView
@property (nonatomic, strong) UILabel *refundReasonLabel;
@property (nonatomic, strong) YunDianRefundDetailModel *refundDetailModel;
@property (nonatomic, strong) NSArray *arrImg;
@property (nonatomic, weak) id <YunDianRefundDetailReasonViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
