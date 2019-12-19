//
//  YunDianDetailBottomView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianOrderListDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YunDianDetailBottomViewClickType){
    YunDianDetailBottomViewClickTypeDonotAgreen,//拒绝退款
    YunDianDetailBottomViewClickTypeAgreen,//同意退款
    YunDianDetailBottomViewClickTypeWriteOff,//核销
    YunDianDetailBottomViewClickTypeDeliverGoods,//发货
    YunDianDetailBottomViewClickTypeViewLogistics,//查看物流
    YunDianDetailBottomViewClickTypeViewOther//其他

};

@protocol YunDianDetailBottomViewDelegate <NSObject>

- (void)yunDianDetailBottomViewBtnClickType:(YunDianDetailBottomViewClickType)ClickType;

@end


@interface YunDianDetailBottomView : UIView
@property (nonatomic, weak) id<YunDianDetailBottomViewDelegate>delegate;
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UIButton *btnRightRed;
- (void)showRefundBtn;
- (void)yunDianDetailBottomViewBtnShow:(YunDianOrderListDetailModel *)orderListModel;
@end

NS_ASSUME_NONNULL_END
