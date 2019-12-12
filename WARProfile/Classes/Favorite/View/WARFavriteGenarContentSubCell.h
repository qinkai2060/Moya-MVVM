//
//  WARFavriteGenarContentSubCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import <UIKit/UIKit.h>
#import "WARFavoriteModel.h"
@interface WARFavriteGenarContentSubCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *coverimageV;

@property (nonatomic,strong) UIImageView *bgV;

@property (nonatomic,strong) UIButton *favriteBtn; // hander

@property (nonatomic,strong) UIButton *editingBtn;

@property (nonatomic,strong) UIView *opaqueV;

@property (nonatomic,strong) UILabel *countlb;

@property (nonatomic,strong) UIButton *lockImageV;

@property (nonatomic,strong) UILabel *titlelb;

@property (nonatomic,strong) UIView *coverV;

@property (nonatomic,strong) WARFavoriteInfoModel *model;
@end
