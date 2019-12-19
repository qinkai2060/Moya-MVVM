//
//  HFDefaultAddressView.h
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFDefaultAddressCell : UITableViewCell
@property (nonatomic,strong) UIImageView *selectImageV;
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *phoneNmLb;
@property (nonatomic,strong) UILabel *defaultAdrLb;
@property (nonatomic,strong) UILabel *tagLb;
@property (nonatomic,strong) UILabel *detailAdressLb;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,assign) NSInteger isEmpty;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UIButton *enterEditingBtn;
@property(nonatomic,strong) HFAddressModel *model;
@property (nonatomic, copy) void (^didSelectPhotoBlock)();
- (void)doSommthing ;
@end

NS_ASSUME_NONNULL_END
