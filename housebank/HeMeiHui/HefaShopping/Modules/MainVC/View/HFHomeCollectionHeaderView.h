//
//  HFHomeCollectionHeaderView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFSectionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFHomeCollectionHeaderView : HFView
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIImageView *leftImageView;
@property(nonatomic,strong) UIImageView *rightImageView;
@property(nonatomic,strong) UILabel *titilelb;
@property(nonatomic,strong) HFSectionModel *sectionModel;
- (void)hh_bindViewModel;
@end

NS_ASSUME_NONNULL_END
