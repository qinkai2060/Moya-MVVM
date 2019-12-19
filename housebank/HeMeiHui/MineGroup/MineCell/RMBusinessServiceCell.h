//
//  RMBusinessServiceCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckShopsModel.h"
#import "UserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RMBusinessServiceCell : UITableViewCell
@property(nonatomic, strong) UIImageView *iconImage;
@property(nonatomic, strong) UILabel *nameLable;
@property(nonatomic, strong) UIImageView *btnImage;
@property(nonatomic, strong) UILabel *lineLable;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)NSMutableArray * imageArray;
- (void)refreshCellWithModel:(CheckShopsModel*)checkShopsModel withUserInfo:(UserInfoModel*)userInfoModel objectAtIndex:(NSInteger)indexPath;
@end

NS_ASSUME_NONNULL_END
