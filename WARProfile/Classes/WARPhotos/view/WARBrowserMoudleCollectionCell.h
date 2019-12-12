//
//  WARBrowserMoudleCollectionCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import <UIKit/UIKit.h>
@class WARPictureModel;

@interface WARBrowserMoudleCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *photoImgV;
@property(nonatomic,strong)UILabel *desclb;
@property(nonatomic,strong)WARPictureModel *model;
@property(nonatomic,strong)UIView *maskV;
@end
