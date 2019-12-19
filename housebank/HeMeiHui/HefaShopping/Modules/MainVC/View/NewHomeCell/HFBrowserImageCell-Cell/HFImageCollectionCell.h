//
//  HFImageCollectionCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFBrowserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFImageCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *textlb;
@property(nonatomic,strong)HFBrowserModel *model;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END
