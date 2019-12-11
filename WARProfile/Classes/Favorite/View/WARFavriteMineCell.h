//
//  WARFavriteMineCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//
//collect_book_bg
#import <UIKit/UIKit.h>
#import "WARFavoriteModel.h"
@interface WARFavriteMineCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UIImageView *bgV;
@property (nonatomic,strong) UIButton *handlerBtn;
@property (nonatomic,strong) UIView *maskV;
@property (nonatomic,strong) UIImageView *maskV2;
@property (nonatomic,strong) UILabel *countlb;
@property (nonatomic,strong) UIButton *lockImageV;
@property (nonatomic,strong) UILabel *titlelb;
@property (nonatomic,strong) WARFavoriteInfoModel *model;
@end
