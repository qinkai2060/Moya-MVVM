//
//  MyDeleteUserImageCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyDeleteAccountCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDeleteUserImageCell : MyDeleteAccountCell
@property(nonatomic,strong)UIImageView *iconimageView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *subTitleLb;
@property(nonatomic,strong)UIView *lineView;

@end

NS_ASSUME_NONNULL_END
