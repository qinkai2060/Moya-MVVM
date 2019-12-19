//
//  HMHVideoPreviewTopView.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/20.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"
// 直播预告页 顶部的view
typedef void(^backBtnClickBlock)();
typedef void(^shareBtbClickBlock)();
typedef void(^toSeePreviewBlock)();
typedef void(^yuYueBtnClickBlock)();
@interface HMHVideoPreviewTopView : UIView

@property (nonatomic, strong) backBtnClickBlock backClickBlock;
@property (nonatomic, strong) shareBtbClickBlock shareBtnBlock;
@property (nonatomic, strong) toSeePreviewBlock seePreViewBlock;
@property (nonatomic, strong) yuYueBtnClickBlock yuYueBtnClick;
// 预约观看btn
@property (nonatomic, strong) UIButton *previewBtn;

- (void)refreshViewWithModel:(HMHVideoListModel *)model;

@end
