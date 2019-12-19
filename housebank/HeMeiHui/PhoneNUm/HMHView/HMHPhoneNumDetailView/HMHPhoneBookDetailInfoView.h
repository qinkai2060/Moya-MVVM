//
//  HMHPhoneBookDetailInfoView.h
//  housebank
//
//  Created by Qianhong Li on 2017/11/2.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHPersonInfoModel.h"
#import "HMHPhoneBookDetailInfoModel.h"

typedef void(^guanZhuBtnClick)(UIButton *guanZhuBtn);

@interface HMHPhoneBookDetailInfoView : UIView

@property (nonatomic, strong) guanZhuBtnClick guanZhuClick;

- (void)reshDetailInfoViewWithModel:(HMHPersonInfoModel *)infoModel withDetailModel:(HMHPhoneBookDetailInfoModel *)detailModel;

@end
