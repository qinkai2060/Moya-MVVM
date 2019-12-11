//
//  WARTagLableView.h
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

@interface WARTagLableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end
