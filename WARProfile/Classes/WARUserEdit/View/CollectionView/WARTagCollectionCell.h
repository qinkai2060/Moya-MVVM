//
//  WARTagCollectionCell.h
//  Pods
//
//  Created by huange on 2017/8/25.
//
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
#import "UIImage+WARBundleImage.h"
#import "WARLocalizedHelper.h"
#import "WARUIHelper.h"
#import "WARMacros.h"

@interface WARTagCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, assign) BOOL isSelected;

@end


@interface WAREmptyCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end
