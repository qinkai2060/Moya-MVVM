//
//  GroupBuyingCollectionViewCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/1.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGroupList.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyingCollectionViewCell : UICollectionViewCell
/* 头像 */
@property (strong , nonatomic)UIImageView *iconImageView;
/* 昵称 */
@property (strong , nonatomic)UILabel *nameLabel;
/* 参团内容 */
@property (strong , nonatomic)UILabel *contentLabel;;
/* 去参团按钮 */
@property (strong , nonatomic)UIButton *goGroupBtn;
//  分割线
@property (strong , nonatomic) UILabel *spaceLabe;

- (void)reSetSelectedData:(OpenGroupListItem *)model;
@end

NS_ASSUME_NONNULL_END
