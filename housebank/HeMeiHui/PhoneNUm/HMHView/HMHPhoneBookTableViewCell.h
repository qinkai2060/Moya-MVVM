//
//  HMHPhoneBookTableViewCell.h
//  PhoneNumDemo
//
//  Created by Qianhong Li on 2017/8/31.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHPersonInfoModel.h"

@class HMHPhoneBookTableViewCell;

typedef void(^cellBtnClick)(HMHPhoneBookTableViewCell *cell);

typedef void(^chatBtnClick)(HMHPhoneBookTableViewCell *cell);

@interface HMHPhoneBookTableViewCell : UITableViewCell


@property (nonatomic, strong) UIButton *stateBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) cellBtnClick clickBtnBlock;

@property (nonatomic, copy) chatBtnClick chatBtnBlock;

- (void)refreshTableViewCellWithInfoModel:(HMHPersonInfoModel *)model;

@end
