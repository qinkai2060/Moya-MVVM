//
//  HFPCCSelectoryCell.h
//  housebank
//
//  Created by usermac on 2018/11/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFPCCSelectorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFPCCSelectoryCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImageView *signImagV;
@property (nonatomic,strong) HFPCCSelectorModel *model;
- (void)dosomthing;
@end

NS_ASSUME_NONNULL_END
